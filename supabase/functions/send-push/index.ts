// Supabase Edge Function: send-push
// Sends push notifications via Apple Push Notification service (APNs)
//
// Deploy with: supabase functions deploy send-push
// Set secrets with:
//   supabase secrets set APNS_KEY_ID=S6TK6H5AP4
//   supabase secrets set APNS_TEAM_ID=YOUR_TEAM_ID
//   supabase secrets set APNS_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"
//   supabase secrets set BUNDLE_ID=com.kinder.petnames

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"
import * as jose from "https://deno.land/x/jose@v4.14.4/index.ts"

const APNS_KEY_ID = Deno.env.get('APNS_KEY_ID') || 'S6TK6H5AP4'
const APNS_TEAM_ID = Deno.env.get('APNS_TEAM_ID') || '9V592235FH'
const APNS_PRIVATE_KEY = Deno.env.get('APNS_PRIVATE_KEY') || ''
const BUNDLE_ID = Deno.env.get('BUNDLE_ID') || 'com.kerryman.petnames'

// APNs endpoints
const APNS_HOST_PRODUCTION = 'api.push.apple.com'
const APNS_HOST_SANDBOX = 'api.sandbox.push.apple.com'

interface PushRequest {
  type: 'match' | 'new_member'
  household_id: string
  exclude_user_id?: string
  payload: {
    name?: string
    member_name?: string
  }
}

// Generate JWT for APNs authentication
async function generateAPNsToken(): Promise<string> {
  const privateKey = await jose.importPKCS8(APNS_PRIVATE_KEY, 'ES256')
  
  const jwt = await new jose.SignJWT({})
    .setProtectedHeader({ 
      alg: 'ES256', 
      kid: APNS_KEY_ID 
    })
    .setIssuer(APNS_TEAM_ID)
    .setIssuedAt()
    .sign(privateKey)
  
  return jwt
}

// Send push notification to a single device
async function sendPushToDevice(
  token: string, 
  title: string, 
  body: string, 
  data: Record<string, string>,
  useSandbox: boolean = true
): Promise<boolean> {
  try {
    const jwt = await generateAPNsToken()
    const host = useSandbox ? APNS_HOST_SANDBOX : APNS_HOST_PRODUCTION
    
    const payload = {
      aps: {
        alert: {
          title,
          body
        },
        sound: 'default',
        badge: 1
      },
      ...data
    }
    
    const response = await fetch(`https://${host}/3/device/${token}`, {
      method: 'POST',
      headers: {
        'authorization': `bearer ${jwt}`,
        'apns-topic': BUNDLE_ID,
        'apns-push-type': 'alert',
        'apns-priority': '10',
        'content-type': 'application/json'
      },
      body: JSON.stringify(payload)
    })
    
    if (!response.ok) {
      const error = await response.text()
      console.error(`APNs error for token ${token.substring(0, 10)}...: ${error}`)
      return false
    }
    
    console.log(`✅ Push sent to ${token.substring(0, 10)}...`)
    return true
  } catch (error) {
    console.error(`Failed to send push: ${error}`)
    return false
  }
}

serve(async (req) => {
  // CORS headers
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      }
    })
  }

  try {
    const { type, household_id, exclude_user_id, payload }: PushRequest = await req.json()
    
    // Create Supabase client
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseKey)
    
    // Get push tokens for the household
    const { data: tokens, error } = await supabase
      .rpc('get_household_push_tokens', {
        p_household_id: household_id,
        p_exclude_user_id: exclude_user_id || null
      })
    
    if (error) {
      console.error('Error fetching tokens:', error)
      return new Response(JSON.stringify({ error: 'Failed to fetch tokens' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      })
    }
    
    if (!tokens || tokens.length === 0) {
      return new Response(JSON.stringify({ 
        success: true, 
        message: 'No tokens to send to',
        sent: 0 
      }), {
        headers: { 'Content-Type': 'application/json' }
      })
    }
    
    // Prepare notification content based on type
    let title: string
    let body: string
    let data: Record<string, string> = { type }
    
    switch (type) {
      case 'match':
        title = "🎉 It's a Match!"
        body = `Jullie vinden '${payload.name}' allebei een geweldige naam!`
        data.name = payload.name || ''
        break
        
      case 'new_member':
        title = "👋 Nieuw lid!"
        body = `${payload.member_name} is toegetreden tot je household!`
        data.member_name = payload.member_name || ''
        break
        
      default:
        return new Response(JSON.stringify({ error: 'Unknown notification type' }), {
          status: 400,
          headers: { 'Content-Type': 'application/json' }
        })
    }
    
    // Send to all devices
    const results = await Promise.all(
      tokens.map((t: { push_token: string }) => 
        sendPushToDevice(t.push_token, title, body, data)
      )
    )
    
    const successCount = results.filter(r => r).length
    
    // Log the notification
    await supabase.from('notification_log').insert({
      household_id,
      type,
      payload: {
        ...payload,
        sent_to: tokens.length,
        success_count: successCount
      }
    })
    
    return new Response(JSON.stringify({ 
      success: true, 
      sent: successCount,
      total: tokens.length 
    }), {
      headers: { 'Content-Type': 'application/json' }
    })
    
  } catch (error) {
    console.error('Error:', error)
    return new Response(JSON.stringify({ error: String(error) }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
})

-- =====================================================
-- Migration: Add language and style columns to name_sets
-- Run this BEFORE the seed data
-- =====================================================

-- Add new columns
ALTER TABLE name_sets 
ADD COLUMN IF NOT EXISTS language text,
ADD COLUMN IF NOT EXISTS style text,
ADD COLUMN IF NOT EXISTS description text;

-- Add unique constraint (after populating data, or drop/recreate if needed)
-- We'll add this after seed data is inserted
-- ALTER TABLE name_sets ADD CONSTRAINT name_sets_language_style_key UNIQUE (language, style);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_name_sets_language ON name_sets(language);
CREATE INDEX IF NOT EXISTS idx_name_sets_style ON name_sets(style);
CREATE INDEX IF NOT EXISTS idx_name_sets_language_style ON name_sets(language, style);

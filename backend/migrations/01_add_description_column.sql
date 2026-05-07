-- Add description column to companies table
ALTER TABLE companies 
ADD COLUMN IF NOT EXISTS description TEXT;

-- Note: Using TEXT type for description as it can be long
ALTER TABLE companies 
ALTER COLUMN description TYPE text;

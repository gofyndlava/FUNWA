-- Add Model columns to StencilMaster and SpiMaster tables
-- This allows storing the model information when creating stencils and SPI

-- Add Model column to StencilMaster if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'StencilMaster' 
        AND column_name = 'Model'
    ) THEN
        ALTER TABLE "StencilMaster" ADD COLUMN "Model" VARCHAR(100);
        CREATE INDEX IF NOT EXISTS idx_stencilmaster_model ON "StencilMaster"("Model");
    END IF;
END $$;

-- Add Model column to SpiMaster if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'SpiMaster' 
        AND column_name = 'Model'
    ) THEN
        ALTER TABLE "SpiMaster" ADD COLUMN "Model" VARCHAR(100);
        CREATE INDEX IF NOT EXISTS idx_spimaster_model ON "SpiMaster"("Model");
    END IF;
END $$;

-- Update existing records with sample models (optional - for demo data)
UPDATE "StencilMaster" SET "Model" = CASE 
    WHEN "Stencil_id" LIKE 'ST%' THEN 'MODEL-A'
    ELSE 'MODEL-A'
END WHERE "Model" IS NULL;

UPDATE "SpiMaster" SET "Model" = CASE 
    WHEN "Spi_id" LIKE 'SPI%' THEN 'SPI-MODEL-A'
    ELSE 'SPI-MODEL-A'
END WHERE "Model" IS NULL;

-- Verify columns were added
SELECT 
    'StencilMaster' as table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'StencilMaster' AND column_name = 'Model'
UNION ALL
SELECT 
    'SpiMaster' as table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'SpiMaster' AND column_name = 'Model';


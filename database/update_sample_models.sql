-- Update sample data to assign proper models to stencils and SPI
-- This ensures demo data has meaningful model associations

-- Update StencilMaster with diverse models
UPDATE "StencilMaster" SET "Model" = CASE
    WHEN "Stencil_id" IN ('ST001', 'ST006', 'ST011', 'ST016', 'ST021') THEN 'MODEL-A'
    WHEN "Stencil_id" IN ('ST002', 'ST007', 'ST012', 'ST017', 'ST022') THEN 'MODEL-B'
    WHEN "Stencil_id" IN ('ST003', 'ST008', 'ST013', 'ST018', 'ST023') THEN 'MODEL-C'
    WHEN "Stencil_id" IN ('ST004', 'ST009', 'ST014', 'ST019', 'ST024') THEN 'MODEL-D'
    WHEN "Stencil_id" IN ('ST005', 'ST010', 'ST015', 'ST020', 'ST025') THEN 'MODEL-E'
    ELSE 'MODEL-A'
END WHERE "Model" IS NULL OR "Model" = 'MODEL-A';

-- Update SpiMaster with diverse models
UPDATE "SpiMaster" SET "Model" = CASE
    WHEN "Spi_id" = 'SPI001' THEN 'SPI-MODEL-A'
    WHEN "Spi_id" = 'SPI002' THEN 'SPI-MODEL-B'
    WHEN "Spi_id" = 'SPI003' THEN 'SPI-MODEL-C'
    WHEN "Spi_id" = 'SPI004' THEN 'SPI-MODEL-A'
    WHEN "Spi_id" = 'SPI005' THEN 'SPI-MODEL-B'
    ELSE 'SPI-MODEL-A'
END WHERE "Model" IS NULL OR "Model" = 'SPI-MODEL-A';

-- Verify updates
SELECT 'StencilMaster' as table_name, "Stencil_id", "Model", "currentstencil_status" 
FROM "StencilMaster" 
ORDER BY "Stencil_id" 
LIMIT 10;

SELECT 'SpiMaster' as table_name, "Spi_id", "Model", "currentstencil_status" 
FROM "SpiMaster" 
ORDER BY "Spi_id";


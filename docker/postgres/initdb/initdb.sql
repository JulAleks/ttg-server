-- Create enums
CREATE TYPE enum_asset_type AS ENUM ('character', 'quest', 'map', 'location');
CREATE TYPE enum_visibility AS ENUM ('public', 'private', 'unlisted');
CREATE TYPE enum_character_race AS ENUM ('human', 'elf', 'drow', 'half_elf', 'half_orc', 'halfling', 'dwarf', 'gnome', 'tiefling', 'githyanki', 'dragonborn');
CREATE TYPE enum_character_class AS ENUM ('barbarian', 'bard', 'cleric', 'druid', 'fighter', 'monk', 'paladin', 'ranger', 'rogue', 'sorcerer', 'warlock', 'wizard');
CREATE TYPE enum_character_gender AS ENUM ('male', 'female', 'non_binary', 'genderfluid', 'agender');
CREATE TYPE enum_character_alignment AS ENUM ('lawful_good', 'neutral_good', 'chaotic_good', 'lawful_neutral', 'true_neutral', 'chaotic_neutral', 'lawful_evil', 'neutral_evil', 'chaotic_evil');

-- Create User table
CREATE TABLE "User" (
    "id" SERIAL PRIMARY KEY,
    "hashed_email" TEXT NOT NULL UNIQUE,
    "display_name" VARCHAR(100) NOT NULL,
    "join_date" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "profile_bio" TEXT,
    "profile_picture_url" TEXT,
    "profile_picture_url_expiry" TIMESTAMP
);

-- Create Asset table
CREATE TABLE "Asset" (
    "id" SERIAL PRIMARY KEY,
    "creator_id" INT NOT NULL REFERENCES "User"("id") ON DELETE CASCADE,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "visibility" enum_visibility NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_featured" BOOLEAN NOT NULL DEFAULT FALSE,
    "likes" INT NOT NULL DEFAULT 0,
    "type" enum_asset_type NOT NULL,
    "image_url" TEXT,
    "image_url_expiry" TIMESTAMP
);

-- Create Character table
CREATE TABLE "Character" (
    "asset_id" INT PRIMARY KEY REFERENCES "Asset"("id") ON DELETE CASCADE,
    "race" enum_character_race NOT NULL,
    "class" enum_character_class NOT NULL,
    "gender" enum_character_gender NOT NULL,
    "alignment" enum_character_alignment NOT NULL,
    "appearance" TEXT,
    "personality" TEXT,
    "background" TEXT,
    "abilities" TEXT,
    "equipment" TEXT,
    "motivation" TEXT,
    "pose" TEXT
);

-- -- Create Location table
-- CREATE TABLE "Location" (
--     "asset_id" INT PRIMARY KEY REFERENCES "Asset"("id") ON DELETE CASCADE
-- );

-- -- Create Quest table
-- CREATE TABLE "Quest" (
--     "asset_id" INT PRIMARY KEY REFERENCES "Asset"("id") ON DELETE CASCADE
-- );

-- -- Create Map table
-- CREATE TABLE "Map" (
--     "asset_id" INT PRIMARY KEY REFERENCES "Asset"("id") ON DELETE CASCADE
-- );

-- Create Comment table
CREATE TABLE "Comment" (
    "id" SERIAL PRIMARY KEY,
    "asset_id" INT NOT NULL REFERENCES "Asset"("id") ON DELETE CASCADE,
    "author_id" INT NOT NULL REFERENCES "User"("id") ON DELETE CASCADE,
    "created_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "body" TEXT NOT NULL
);

-- Create Collection table
CREATE TABLE "Collection" (
    "id" SERIAL PRIMARY KEY,
    "creator_id" INT NOT NULL REFERENCES "User"("id") ON DELETE CASCADE,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "visibility" enum_visibility NOT NULL
);

-- Create Asset To Collection many-to-many table
CREATE TABLE "_AssetToCollection" (
    "A" INT NOT NULL REFERENCES "Asset"("id") ON DELETE CASCADE,
    "B" INT NOT NULL REFERENCES "Collection"("id") ON DELETE CASCADE
);

-- Create indices for Prisma implicit many-to-many relation
CREATE UNIQUE INDEX "_AssetToCollection_AB_unique" ON "_AssetToCollection"("A" int4_ops,"B" int4_ops);
CREATE INDEX "_AssetToCollection_B_index" ON "_AssetToCollection"("B" int4_ops);

-- DropForeignKey
ALTER TABLE "DisplaySetting" DROP CONSTRAINT "DisplaySetting_storeId_fkey";

-- DropForeignKey
ALTER TABLE "StoreSetting" DROP CONSTRAINT "StoreSetting_storeId_fkey";

-- DropForeignKey
ALTER TABLE "Stripe" DROP CONSTRAINT "Stripe_storeId_fkey";

-- DropForeignKey
ALTER TABLE "UsersOnStores" DROP CONSTRAINT "UsersOnStores_storeId_fkey";

-- DropForeignKey
ALTER TABLE "UsersOnStores" DROP CONSTRAINT "UsersOnStores_userId_fkey";

-- AddForeignKey
ALTER TABLE "UsersOnStores" ADD CONSTRAINT "UsersOnStores_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersOnStores" ADD CONSTRAINT "UsersOnStores_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "Store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Stripe" ADD CONSTRAINT "Stripe_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "Store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DisplaySetting" ADD CONSTRAINT "DisplaySetting_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "Store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoreSetting" ADD CONSTRAINT "StoreSetting_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "Store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- RenameIndex
ALTER INDEX "DisplaySetting.storeId_unique" RENAME TO "DisplaySetting_storeId_key";

-- RenameIndex
ALTER INDEX "Store.hash_unique" RENAME TO "Store_hash_key";

-- RenameIndex
ALTER INDEX "StoreSetting.storeId_unique" RENAME TO "StoreSetting_storeId_key";

-- RenameIndex
ALTER INDEX "Stripe.storeId_unique" RENAME TO "Stripe_storeId_key";

-- RenameIndex
ALTER INDEX "User.email_unique" RENAME TO "User_email_key";

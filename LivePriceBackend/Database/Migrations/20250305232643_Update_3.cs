using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LivePriceBackend.Database.Migrations
{
    /// <inheritdoc />
    public partial class Update_3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityGroupVisibility_Customers_CustomerId",
                table: "CustomerParityGroupVisibility");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityGroupVisibility_ParityGroups_ParityGroupId",
                table: "CustomerParityGroupVisibility");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityGroupVisibility_Users_CreatedById",
                table: "CustomerParityGroupVisibility");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityGroupVisibility_Users_DeletedById",
                table: "CustomerParityGroupVisibility");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityGroupVisibility_Users_UpdatedById",
                table: "CustomerParityGroupVisibility");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityVisibility_Customers_CustomerId",
                table: "CustomerParityVisibility");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityVisibility_Parities_ParityId",
                table: "CustomerParityVisibility");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityVisibility_Users_CreatedById",
                table: "CustomerParityVisibility");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityVisibility_Users_DeletedById",
                table: "CustomerParityVisibility");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityVisibility_Users_UpdatedById",
                table: "CustomerParityVisibility");

            migrationBuilder.DropPrimaryKey(
                name: "PK_CustomerParityVisibility",
                table: "CustomerParityVisibility");

            migrationBuilder.DropPrimaryKey(
                name: "PK_CustomerParityGroupVisibility",
                table: "CustomerParityGroupVisibility");

            migrationBuilder.RenameTable(
                name: "CustomerParityVisibility",
                newName: "CustomerParityVisibilities");

            migrationBuilder.RenameTable(
                name: "CustomerParityGroupVisibility",
                newName: "CustomerParityGroupVisibilities");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityVisibility_UpdatedById",
                table: "CustomerParityVisibilities",
                newName: "IX_CustomerParityVisibilities_UpdatedById");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityVisibility_ParityId",
                table: "CustomerParityVisibilities",
                newName: "IX_CustomerParityVisibilities_ParityId");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityVisibility_DeletedById",
                table: "CustomerParityVisibilities",
                newName: "IX_CustomerParityVisibilities_DeletedById");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityVisibility_CustomerId",
                table: "CustomerParityVisibilities",
                newName: "IX_CustomerParityVisibilities_CustomerId");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityVisibility_CreatedById",
                table: "CustomerParityVisibilities",
                newName: "IX_CustomerParityVisibilities_CreatedById");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityGroupVisibility_UpdatedById",
                table: "CustomerParityGroupVisibilities",
                newName: "IX_CustomerParityGroupVisibilities_UpdatedById");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityGroupVisibility_ParityGroupId",
                table: "CustomerParityGroupVisibilities",
                newName: "IX_CustomerParityGroupVisibilities_ParityGroupId");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityGroupVisibility_DeletedById",
                table: "CustomerParityGroupVisibilities",
                newName: "IX_CustomerParityGroupVisibilities_DeletedById");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityGroupVisibility_CustomerId",
                table: "CustomerParityGroupVisibilities",
                newName: "IX_CustomerParityGroupVisibilities_CustomerId");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityGroupVisibility_CreatedById",
                table: "CustomerParityGroupVisibilities",
                newName: "IX_CustomerParityGroupVisibilities_CreatedById");

            migrationBuilder.AlterColumn<int>(
                name: "Scale",
                table: "Parities",
                type: "int",
                nullable: false,
                defaultValue: 2,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddPrimaryKey(
                name: "PK_CustomerParityVisibilities",
                table: "CustomerParityVisibilities",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_CustomerParityGroupVisibilities",
                table: "CustomerParityGroupVisibilities",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityGroupVisibilities_Customers_CustomerId",
                table: "CustomerParityGroupVisibilities",
                column: "CustomerId",
                principalTable: "Customers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityGroupVisibilities_ParityGroups_ParityGroupId",
                table: "CustomerParityGroupVisibilities",
                column: "ParityGroupId",
                principalTable: "ParityGroups",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityGroupVisibilities_Users_CreatedById",
                table: "CustomerParityGroupVisibilities",
                column: "CreatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityGroupVisibilities_Users_DeletedById",
                table: "CustomerParityGroupVisibilities",
                column: "DeletedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityGroupVisibilities_Users_UpdatedById",
                table: "CustomerParityGroupVisibilities",
                column: "UpdatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityVisibilities_Customers_CustomerId",
                table: "CustomerParityVisibilities",
                column: "CustomerId",
                principalTable: "Customers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityVisibilities_Parities_ParityId",
                table: "CustomerParityVisibilities",
                column: "ParityId",
                principalTable: "Parities",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityVisibilities_Users_CreatedById",
                table: "CustomerParityVisibilities",
                column: "CreatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityVisibilities_Users_DeletedById",
                table: "CustomerParityVisibilities",
                column: "DeletedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityVisibilities_Users_UpdatedById",
                table: "CustomerParityVisibilities",
                column: "UpdatedById",
                principalTable: "Users",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityGroupVisibilities_Customers_CustomerId",
                table: "CustomerParityGroupVisibilities");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityGroupVisibilities_ParityGroups_ParityGroupId",
                table: "CustomerParityGroupVisibilities");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityGroupVisibilities_Users_CreatedById",
                table: "CustomerParityGroupVisibilities");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityGroupVisibilities_Users_DeletedById",
                table: "CustomerParityGroupVisibilities");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityGroupVisibilities_Users_UpdatedById",
                table: "CustomerParityGroupVisibilities");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityVisibilities_Customers_CustomerId",
                table: "CustomerParityVisibilities");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityVisibilities_Parities_ParityId",
                table: "CustomerParityVisibilities");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityVisibilities_Users_CreatedById",
                table: "CustomerParityVisibilities");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityVisibilities_Users_DeletedById",
                table: "CustomerParityVisibilities");

            migrationBuilder.DropForeignKey(
                name: "FK_CustomerParityVisibilities_Users_UpdatedById",
                table: "CustomerParityVisibilities");

            migrationBuilder.DropPrimaryKey(
                name: "PK_CustomerParityVisibilities",
                table: "CustomerParityVisibilities");

            migrationBuilder.DropPrimaryKey(
                name: "PK_CustomerParityGroupVisibilities",
                table: "CustomerParityGroupVisibilities");

            migrationBuilder.RenameTable(
                name: "CustomerParityVisibilities",
                newName: "CustomerParityVisibility");

            migrationBuilder.RenameTable(
                name: "CustomerParityGroupVisibilities",
                newName: "CustomerParityGroupVisibility");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityVisibilities_UpdatedById",
                table: "CustomerParityVisibility",
                newName: "IX_CustomerParityVisibility_UpdatedById");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityVisibilities_ParityId",
                table: "CustomerParityVisibility",
                newName: "IX_CustomerParityVisibility_ParityId");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityVisibilities_DeletedById",
                table: "CustomerParityVisibility",
                newName: "IX_CustomerParityVisibility_DeletedById");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityVisibilities_CustomerId",
                table: "CustomerParityVisibility",
                newName: "IX_CustomerParityVisibility_CustomerId");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityVisibilities_CreatedById",
                table: "CustomerParityVisibility",
                newName: "IX_CustomerParityVisibility_CreatedById");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityGroupVisibilities_UpdatedById",
                table: "CustomerParityGroupVisibility",
                newName: "IX_CustomerParityGroupVisibility_UpdatedById");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityGroupVisibilities_ParityGroupId",
                table: "CustomerParityGroupVisibility",
                newName: "IX_CustomerParityGroupVisibility_ParityGroupId");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityGroupVisibilities_DeletedById",
                table: "CustomerParityGroupVisibility",
                newName: "IX_CustomerParityGroupVisibility_DeletedById");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityGroupVisibilities_CustomerId",
                table: "CustomerParityGroupVisibility",
                newName: "IX_CustomerParityGroupVisibility_CustomerId");

            migrationBuilder.RenameIndex(
                name: "IX_CustomerParityGroupVisibilities_CreatedById",
                table: "CustomerParityGroupVisibility",
                newName: "IX_CustomerParityGroupVisibility_CreatedById");

            migrationBuilder.AlterColumn<int>(
                name: "Scale",
                table: "Parities",
                type: "int",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int",
                oldDefaultValue: 2);

            migrationBuilder.AddPrimaryKey(
                name: "PK_CustomerParityVisibility",
                table: "CustomerParityVisibility",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_CustomerParityGroupVisibility",
                table: "CustomerParityGroupVisibility",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityGroupVisibility_Customers_CustomerId",
                table: "CustomerParityGroupVisibility",
                column: "CustomerId",
                principalTable: "Customers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityGroupVisibility_ParityGroups_ParityGroupId",
                table: "CustomerParityGroupVisibility",
                column: "ParityGroupId",
                principalTable: "ParityGroups",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityGroupVisibility_Users_CreatedById",
                table: "CustomerParityGroupVisibility",
                column: "CreatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityGroupVisibility_Users_DeletedById",
                table: "CustomerParityGroupVisibility",
                column: "DeletedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityGroupVisibility_Users_UpdatedById",
                table: "CustomerParityGroupVisibility",
                column: "UpdatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityVisibility_Customers_CustomerId",
                table: "CustomerParityVisibility",
                column: "CustomerId",
                principalTable: "Customers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityVisibility_Parities_ParityId",
                table: "CustomerParityVisibility",
                column: "ParityId",
                principalTable: "Parities",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityVisibility_Users_CreatedById",
                table: "CustomerParityVisibility",
                column: "CreatedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityVisibility_Users_DeletedById",
                table: "CustomerParityVisibility",
                column: "DeletedById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_CustomerParityVisibility_Users_UpdatedById",
                table: "CustomerParityVisibility",
                column: "UpdatedById",
                principalTable: "Users",
                principalColumn: "Id");
        }
    }
}

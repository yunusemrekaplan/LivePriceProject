using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LivePriceBackend.Database.Migrations
{
    /// <inheritdoc />
    public partial class Update_2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ApiSymbol",
                table: "Parities");

            migrationBuilder.AddColumn<string>(
                name: "RawSymbol",
                table: "Parities",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "Scale",
                table: "Parities",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "AdminPriceRules",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ParityId = table.Column<int>(type: "int", nullable: false),
                    PriceRuleType = table.Column<int>(type: "int", nullable: false),
                    ValueForAsk = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    ValueForBid = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdminPriceRules", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AdminPriceRules_Parities_ParityId",
                        column: x => x.ParityId,
                        principalTable: "Parities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AdminPriceRules_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AdminPriceRules_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AdminPriceRules_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "CustomerParityGroupVisibility",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CustomerId = table.Column<int>(type: "int", nullable: false),
                    ParityGroupId = table.Column<int>(type: "int", nullable: false),
                    IsVisible = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CustomerParityGroupVisibility", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CustomerParityGroupVisibility_Customers_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "Customers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CustomerParityGroupVisibility_ParityGroups_ParityGroupId",
                        column: x => x.ParityGroupId,
                        principalTable: "ParityGroups",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CustomerParityGroupVisibility_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CustomerParityGroupVisibility_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CustomerParityGroupVisibility_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "CustomerParityVisibility",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CustomerId = table.Column<int>(type: "int", nullable: false),
                    ParityId = table.Column<int>(type: "int", nullable: false),
                    IsVisible = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2(0)", nullable: true),
                    CreatedById = table.Column<int>(type: "int", nullable: true),
                    UpdatedById = table.Column<int>(type: "int", nullable: true),
                    DeletedById = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CustomerParityVisibility", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CustomerParityVisibility_Customers_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "Customers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CustomerParityVisibility_Parities_ParityId",
                        column: x => x.ParityId,
                        principalTable: "Parities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CustomerParityVisibility_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CustomerParityVisibility_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CustomerParityVisibility_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_AdminPriceRules_CreatedById",
                table: "AdminPriceRules",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_AdminPriceRules_DeletedById",
                table: "AdminPriceRules",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_AdminPriceRules_ParityId",
                table: "AdminPriceRules",
                column: "ParityId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AdminPriceRules_UpdatedById",
                table: "AdminPriceRules",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityGroupVisibility_CreatedById",
                table: "CustomerParityGroupVisibility",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityGroupVisibility_CustomerId",
                table: "CustomerParityGroupVisibility",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityGroupVisibility_DeletedById",
                table: "CustomerParityGroupVisibility",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityGroupVisibility_ParityGroupId",
                table: "CustomerParityGroupVisibility",
                column: "ParityGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityGroupVisibility_UpdatedById",
                table: "CustomerParityGroupVisibility",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityVisibility_CreatedById",
                table: "CustomerParityVisibility",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityVisibility_CustomerId",
                table: "CustomerParityVisibility",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityVisibility_DeletedById",
                table: "CustomerParityVisibility",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityVisibility_ParityId",
                table: "CustomerParityVisibility",
                column: "ParityId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerParityVisibility_UpdatedById",
                table: "CustomerParityVisibility",
                column: "UpdatedById");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AdminPriceRules");

            migrationBuilder.DropTable(
                name: "CustomerParityGroupVisibility");

            migrationBuilder.DropTable(
                name: "CustomerParityVisibility");

            migrationBuilder.DropColumn(
                name: "RawSymbol",
                table: "Parities");

            migrationBuilder.DropColumn(
                name: "Scale",
                table: "Parities");

            migrationBuilder.AddColumn<string>(
                name: "ApiSymbol",
                table: "Parities",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}

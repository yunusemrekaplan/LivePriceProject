using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LivePriceBackend.Database.Migrations
{
    /// <inheritdoc />
    public partial class Update_1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsEnabled",
                table: "Parities",
                type: "bit",
                nullable: false,
                defaultValue: true);

            migrationBuilder.AddColumn<int>(
                name: "OrderIndex",
                table: "Parities",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "ParityGroupId",
                table: "Parities",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "ParityGroups",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IsEnabled = table.Column<bool>(type: "bit", nullable: false, defaultValue: true),
                    OrderIndex = table.Column<int>(type: "int", nullable: false),
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
                    table.PrimaryKey("PK_ParityGroups", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ParityGroups_Users_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ParityGroups_Users_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ParityGroups_Users_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Parities_ParityGroupId",
                table: "Parities",
                column: "ParityGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_ParityGroups_CreatedById",
                table: "ParityGroups",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_ParityGroups_DeletedById",
                table: "ParityGroups",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_ParityGroups_UpdatedById",
                table: "ParityGroups",
                column: "UpdatedById");

            migrationBuilder.AddForeignKey(
                name: "FK_Parities_ParityGroups_ParityGroupId",
                table: "Parities",
                column: "ParityGroupId",
                principalTable: "ParityGroups",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Parities_ParityGroups_ParityGroupId",
                table: "Parities");

            migrationBuilder.DropTable(
                name: "ParityGroups");

            migrationBuilder.DropIndex(
                name: "IX_Parities_ParityGroupId",
                table: "Parities");

            migrationBuilder.DropColumn(
                name: "IsEnabled",
                table: "Parities");

            migrationBuilder.DropColumn(
                name: "OrderIndex",
                table: "Parities");

            migrationBuilder.DropColumn(
                name: "ParityGroupId",
                table: "Parities");
        }
    }
}

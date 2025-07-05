using Microsoft.EntityFrameworkCore;
using DockerAssessment.MvcApp.Models;

namespace DockerAssessment.MvcApp.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<Product> Products { get; set; }
        public DbSet<Category> Categories { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Seed data
            modelBuilder.Entity<Category>().HasData(
                new Category { Id = 1, Name = "Electronics", Description = "Electronic devices and gadgets" },
                new Category { Id = 2, Name = "Books", Description = "Books and literature" },
                new Category { Id = 3, Name = "Clothing", Description = "Apparel and accessories" }
            );

            modelBuilder.Entity<Product>().HasData(
                new Product { Id = 1, Name = "Laptop", Description = "High-performance laptop", Price = 999.99m, CategoryId = 1 },
                new Product { Id = 2, Name = "Smartphone", Description = "Latest smartphone model", Price = 699.99m, CategoryId = 1 },
                new Product { Id = 3, Name = "Programming Book", Description = "Learn programming fundamentals", Price = 29.99m, CategoryId = 2 },
                new Product { Id = 4, Name = "T-Shirt", Description = "Comfortable cotton t-shirt", Price = 19.99m, CategoryId = 3 }
            );
        }
    }
}

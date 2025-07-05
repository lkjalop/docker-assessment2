using System.ComponentModel.DataAnnotations;

namespace DockerAssessment.MvcApp.Models
{
    public class Product
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        [StringLength(500)]
        public string Description { get; set; } = string.Empty;
        
        [Required]
        [Range(0.01, 10000.00)]
        public decimal Price { get; set; }
        
        [Required]
        public int CategoryId { get; set; }
        
        public virtual Category? Category { get; set; }
    }
}

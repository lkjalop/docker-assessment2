using System.ComponentModel.DataAnnotations;

namespace DockerAssessment.MvcApp.Models
{
    public class Category
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(50)]
        public string Name { get; set; } = string.Empty;
        
        [StringLength(200)]
        public string Description { get; set; } = string.Empty;
        
        public virtual ICollection<Product> Products { get; set; } = new List<Product>();
    }
}

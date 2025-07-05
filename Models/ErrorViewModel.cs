using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace DockerAssessment.MvcApp.Models
{
    public class ErrorViewModel
    {
        public string? RequestId { get; set; }

        public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
    }
}

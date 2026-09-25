using Microsoft.VisualBasic.FileIO;
using System;
using System.Collections.Generic;
using System.Text;

namespace Shoppix.Application.Common.Models
{
    public class CloudFile
    {
        public string PublicId { get; init; } = null!;
        public string Url { get; init; } = null!;
        public string ContentType { get; init; } = null!;
    }
}

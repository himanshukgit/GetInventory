using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using L_inventory.Models;
namespace L_inventory.Models
{
    public class Env
    {
        public int StudentId { get; set; }
        [Display(Name = "Name")]
        public string StudentName { get; set; }
        public Environmentinfo EnvName { get; set; }

    }
    public enum Environmentinfo
    {
        Dev,
        Prod
    }



}
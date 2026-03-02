using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AI_Resume_Generator
{
	public class UserLogin_Response
	{
		public int resultvalue { get; set; }
		public string resultmessage { get; set; }
	}

	public class UserLogin_Request
	{
		public string name { get; set; }
		public int userid { get; set; }
		public string email { get; set; }
		public string password { get; set; }
		public string process_by { get; set; }
	}

	public class AuthoriseLogin_Request
	{
		public string password { get; set; }
		public string email { get; set; }
	}

	public class AuthoriseLogin_Response
	{
		public int resultvalue { get; set; }
		public string resultmessage { get; set; }
		public string password { get; set; }
	}

	public class GeneralDTO 
	{
		public string firstName { get; set; }
        public string lastName { get; set; }
        public string email { get; set; }
        public string phoneNumber { get; set; }
        public string address { get; set; }

    }

    public class Academics
    {
        public string qualification_level { get; set; }
        public string course { get; set; }
        public string total_marks { get; set; }
        public string marks_obtained { get; set; }
        public string evaluation_metric { get; set; }

    }

    public class Certifications
    {
        public string certification_name { get; set; }
        public string course { get; set; }
        public string total_marks { get; set; }
        public string marks_obtained { get; set; }
        public string evaluation_metric { get; set; }

    }

    public class Internships
    {
        public string internship_name { get; set; }
        public string company_name { get; set; }
        public string role { get; set; }
        public string duration { get; set; }
        public string from_date { get; set; }
        public string to_date { get; set; }
        public string stipend { get; set; }
        public string mentor { get; set; }
        public string internship_type { get; set; }
        public string intern_certificate_path { get; set; }

    }

    public class Languages
    {
        public string Language { get; set; }
        public string proficiency { get; set; }

    }

    public class Skillset
    {
        public string skills { get; set; }
        public string toolchain { get; set; }
        public string domain { get; set; }
        public string softskill { get; set; }

    }


    public class AddResumeData
	{
		public GeneralDTO General { get; set; }
        public List<Academics> Academics { get; set; }
        public List<Certifications> Certifications { get; set; }
        public List<Internships> Internships { get; set; }
        public List<Languages> Languages { get; set; }
        public List<Skillset> Skillset { get; set; }
    }


}
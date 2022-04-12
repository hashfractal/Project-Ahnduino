using System    ;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _1112_hsj
{
	/// <summary>
	/// Member 관리 클래스 
	/// </summary>
	class StuManager
	{
	   #region 싱글톤 : 하나의 객체만 만들수 있는 클래스
		private StuManager() { }

		static StuManager()  
		{
		   
			Singleton = new StuManager();
		}
		static public StuManager Singleton { get; private set; }

		#endregion

		WBDataBase db = new WBDataBase();
			   
		#region 기능메서드

		public List<Student> PrintAll()
		{
			return db.PrintAll();
		}

		public bool InsertStudent(int number, string name, string subject, int grade)
		{
			try
			{
				Student stu = new Student(number, name, subject, grade);

				return db.InsertStudent(stu);
			}
			catch(Exception)
			{
				return false;
			}
		}

		public bool DeleteStudent(int number)
		{
			return db.DeleteStudent(number);
		}

		public Student NumberToStudent(int number)
		{
			return db.NumberToStudent(number);
		}
		
		public bool UpdateStudent(int number, string type, int grade)
		{
			return db.UpdateStudent(number, type, grade);
		}
		#endregion

	}
}

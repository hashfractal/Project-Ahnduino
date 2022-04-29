using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _1112_hsj
{
	public class WBDataBase
	{
		private SqlConnection con = new SqlConnection();

		private void Open()
		{
			const string connstring = @"Server=SJD-1\SQLEXPRESS;database=WB34;uid=sejin;pwd=sejin";
			con.ConnectionString = connstring;
			con.Open();
		}

		private void Close()
		{
			if (con.State == ConnectionState.Open)
			{
				con.Close();
			}
		}

		public List<Student> PrintAll()
		{
			try
			{
				Open();
				string sql = "select * from Student;";
				SqlCommand cmd = new SqlCommand(sql, con);
				SqlDataReader reader = cmd.ExecuteReader();

				List<Student> memlist = new List<Student>();
				while (reader.Read())
				{
					int num = (int)reader["number"];
					string name = (string)reader["name"];
					string subject = (string)reader["subject"];
					int grade = (int)reader["grade"];
					memlist.Add(new Student(num, name, subject, grade));
				}
				reader.Close();
				return memlist;
			}
			finally
			{
				Close();
			}
		}

		public bool InsertStudent(Student stu)
		{
			try
			{
				Open();

				string sql = string.Format(
					"Insert into Student(number, name, subject, grade) values({0}, '{1}', '{2}', {3})", stu.Number, stu.Name, stu.Subject, stu.Grade);
				SqlCommand cmd = new SqlCommand(sql, con);
				if (cmd.ExecuteNonQuery() <= 0)
					throw new Exception("오류");
				return true;
			}
			catch (Exception)
			{
				return false;
			}
			finally
			{
				Close();
			}
		}

		public Student NumberToStudent(int number)
		{
			try
			{
				Open();

				string sql = string.Format("select * from Student where number={0}", number);
				SqlCommand cmd = new SqlCommand(sql, con);
				SqlDataReader reader = cmd.ExecuteReader();

				reader.Read();
				if (reader.HasRows == false)
					return null;
				int num = (int)reader["number"];
				string name = (string)reader["name"];
				string subject = (string)reader["subject"];
				int grade = (int)reader["grade"];

				Student temp = new Student(num, name, subject, grade);
				reader.Close();
				return temp;
			}
			finally { Close(); }
		}

		public bool DeleteStudent(int number)
		{
			try
			{
				Open();
				string sql = string.Format("delete from Student where number = {0}", number);
				SqlCommand cmd = new SqlCommand(sql, con);
				if (cmd.ExecuteNonQuery() <= 0)
					throw new Exception("오류");
				return true;
			}
			catch
			{
				return false;
			}
			finally
			{
				Close();
			}
		}

		public bool UpdateStudent(int number, string type, int grade)
		{
			try
			{
				Open();
				string sql = string.Format("UPDATE Student SET subject = '{0}', grade = {1} WHERE number = {2}", type, grade, number);
				SqlCommand cmd = new SqlCommand(sql, con);
				if (cmd.ExecuteNonQuery() <= 0)
					throw new Exception("오류");
				return true;
			}
			catch
			{
				return false;
			}
			finally
			{
				Close();
			}
		}
	}
}

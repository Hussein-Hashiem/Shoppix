namespace Shoppix.Application.Features.Test;

public class Student
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
}

public  class StudentOperations
{
    private List<Student> Students { get; set; }
    public StudentOperations()
    {
        Students = new List<Student>
            {
                new Student {Id = 1, Name = "Youssef"},
                new Student {Id = 2, Name = "Shaaban"},
                new Student {Id = 3, Name = "Ahmed"},
            };
    }

    public void Add(Student student)
        => Students.Add(student);

    public List<Student> GetAll() => Students;
}

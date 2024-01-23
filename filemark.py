# %%
import sqlite3
import os
import argparse

os.getcwd()
# %%

DATABASE_PATH = os.environ.get('DATABASE_PATH') or 'silver-guide.db'
# %%
# Function to create a database and table with unique constraints
def create_database():
    connection = sqlite3.connect(DATABASE_PATH)
    cursor = connection.cursor()

    # Create a table for projects with unique constraints on name, path, and id
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS Projects (
            id INTEGER PRIMARY KEY,
            project_name TEXT NOT NULL UNIQUE,
            project_path TEXT NOT NULL UNIQUE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE (id, project_name, project_path)
        )
    ''')

    connection.commit()
    connection.close()

# Function to insert project data into the database with error handling for unique constraints
def insert_project(project_name, project_path):
    connection = sqlite3.connect(DATABASE_PATH)
    cursor = connection.cursor()

    try:
        # Normalize the path
        project_path = os.path.normpath(project_path)

        # Handle blank path, replace with the current working directory
        if not project_path or project_path == ".":
            project_path = os.getcwd()

        # Handle '..' path, replace with the parent directory of the current working directory
        elif project_path == '..':
            project_path = os.path.abspath(os.path.join(os.getcwd(), os.pardir))
        
        # Check if project_path is '...'
        elif project_path == '...':
            raise ValueError("Invalid input: '...' is not allowed as project_path.")
        
        # If project name is not provided, derive it from the last folder in the path (leaf)
        if not project_name:
            project_name = os.path.basename(project_path)

        # Check if the path exists
        if os.path.exists(project_path):
            # Insert data into the 'Projects' table
            cursor.execute('INSERT INTO Projects (project_name, project_path) VALUES (?, ?)', (project_name, project_path))
            connection.commit()
        else:
            print(f"Warning: The path '{project_path}' does not exist. Project not inserted.")
    except sqlite3.IntegrityError as e:
        print(f"Error: {e}. Project not inserted due to unique constraint violation.")
    finally:
        connection.close()
    
    return project_name

# Function to fetch and display all Projects from the database
def display_projects():
    connection = sqlite3.connect(DATABASE_PATH)
    cursor = connection.cursor()

    # Fetch all Projects from the 'Projects' table
    cursor.execute('SELECT * FROM Projects')
    Projects = cursor.fetchall()

    # Display the Projects
    for project_id, project_name, project_path, project_created in Projects:
        print(f"Project ID: {project_id}, Name: {project_name}, Path: {project_path}, Creation : {project_created}.")

    connection.close()

# Function to get a project from the database based on ID or name
def get_project(identifier):
    connection = sqlite3.connect(DATABASE_PATH)
    cursor = connection.cursor()

    # Check if the identifier is an integer (ID) or a string (name)
    if isinstance(identifier, int):
        cursor.execute('SELECT * FROM Projects WHERE id = ?', (identifier,))
    elif isinstance(identifier, str):
        cursor.execute('SELECT * FROM Projects WHERE project_name = ?', (identifier,))
    else:
        raise ValueError('Invalid identifier type. Use int for ID or str for name of Project.')

    project = cursor.fetchone()

    connection.close()

    return project

def remove_project(identifier):
    connection = sqlite3.connect(DATABASE_PATH)
    cursor = connection.cursor()

    project = get_project(identifier)

    # Check if the identifier is an integer (ID) or a string (name)
    if isinstance(identifier, int):
        cursor.execute('DELETE FROM Projects WHERE id = ?', (identifier,))
    elif isinstance(identifier, str):
        cursor.execute('DELETE FROM Projects WHERE project_name = ?', (identifier,))
    else:
        raise ValueError('Invalid identifier type. Use int for ID or str for name of Project.')

    connection.commit()
    connection.close()

    return project

def main():
    parser = argparse.ArgumentParser(description='Manage projects and their paths simply.')
    parser.add_argument('arguments', nargs='*', help='Unnamed arguments (treated as path if one, treated as name and path if two)')
    parser.add_argument('-n', '--name', help='Name of the project (optional)')
    parser.add_argument('-p', '--path', help='Path of the project (mandatory)')
    parser.add_argument('-g', '--get', nargs='?', const=True, help='Fetch a project by ID or name')
    parser.add_argument('-r', '--remove', nargs=1, help='Delete a project by ID or name')

    args = parser.parse_args()

    # Create the database and projects table
    create_database()

    # If --get is provided without a value, list all records from the database
    if args.get is not None and args.get is True:
        # GET PROJECTS ALL
        display_projects()
    elif args.get:
        # GET PROJECTS ONE
        # If --get is provided with a value, fetch the specified project and display it
        if args.get.isnumeric():
            args.get = int(args.get)
        
        project = get_project(args.get)
        
        if project:
            project_id, project_name, project_path, project_created = project
            print(f"Project ID: {project_id}, Name: {project_name}, Path: {project_path}, Created At: {project_created}")
        else:
            print("Project not found.")
    elif args.remove:
        # GET PROJECTS ONE
        # If --get is provided with a value, fetch the specified project and display it
        if args.remove[0].isnumeric():
            args.remove[0] = int(args.remove[0])
            
        project = remove_project(args.remove[0])
        if project:
            project_id, project_name, project_path, project_created = project
            print(f"Project ID: {project_id}, Name: {project_name}, Path: {project_path} Deleted Successfully.")
        else:
            print("Project not found.")
    else:
        # INSERT MODE ONE
        # Determine project_name and project_path based on the number of unnamed arguments and named parameters
        if args.path is not None:
            # If --path is provided, consider it as the mandatory path argument
            project_name = args.name
            project_path = args.path
        elif len(args.arguments) == 1:
            # Treats it as a path if one unnamed argument is provided
            project_name = None
            project_path = args.arguments[0]
        elif len(args.arguments) == 2:
            # Treats it as name and path if two unnamed arguments are provided
            project_name = args.arguments[0]
            project_path = args.arguments[1]
        else:
            parser.error('Incorrect arguments. Provide either unnamed arguments or --name and --path or --get.')

        # Insert project based on determined values
        project_name = insert_project(project_name, project_path)

        # Display all projects from the database
        project_id, project_name, project_path, project_created = get_project(project_name)
        print(f"Project ID: {project_id}, Name: {project_name}, Path: {project_path}, Successfully Created.")
# %%

if __name__ == '__main__':
    main()

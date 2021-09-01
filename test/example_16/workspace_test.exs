defmodule Example16.WorkspaceTest do
  use Example16.DataCase

  alias Example16.Workspace

  describe "projects" do
    alias Example16.Workspace.Project

    import Example16.WorkspaceFixtures

    @invalid_attrs %{completed?: nil, description: nil, design_cost: nil, generation: nil, name: nil, remaining: nil, type: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Workspace.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Workspace.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{completed?: true, description: "some description", design_cost: "120.5", generation: 42, name: "some name", remaining: 42, type: "some type"}

      assert {:ok, %Project{} = project} = Workspace.create_project(valid_attrs)
      assert project.completed? == true
      assert project.description == "some description"
      assert project.design_cost == Decimal.new("120.5")
      assert project.generation == 42
      assert project.name == "some name"
      assert project.remaining == 42
      assert project.type == "some type"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workspace.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{completed?: false, description: "some updated description", design_cost: "456.7", generation: 43, name: "some updated name", remaining: 43, type: "some updated type"}

      assert {:ok, %Project{} = project} = Workspace.update_project(project, update_attrs)
      assert project.completed? == false
      assert project.description == "some updated description"
      assert project.design_cost == Decimal.new("456.7")
      assert project.generation == 43
      assert project.name == "some updated name"
      assert project.remaining == 43
      assert project.type == "some updated type"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Workspace.update_project(project, @invalid_attrs)
      assert project == Workspace.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Workspace.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Workspace.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Workspace.change_project(project)
    end
  end

  describe "tasks" do
    alias Example16.Workspace.Task

    import Example16.WorkspaceFixtures

    @invalid_attrs %{cancelled_at: nil, completed_at: nil, description: nil, generation: nil, started_at: nil, status: nil, type: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Workspace.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Workspace.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{cancelled_at: ~U[2021-08-31 19:29:00.000000Z], completed_at: ~U[2021-08-31 19:29:00.000000Z], description: "some description", generation: 42, started_at: ~U[2021-08-31 19:29:00.000000Z], status: "some status", type: "some type"}

      assert {:ok, %Task{} = task} = Workspace.create_task(valid_attrs)
      assert task.cancelled_at == ~U[2021-08-31 19:29:00.000000Z]
      assert task.completed_at == ~U[2021-08-31 19:29:00.000000Z]
      assert task.description == "some description"
      assert task.generation == 42
      assert task.started_at == ~U[2021-08-31 19:29:00.000000Z]
      assert task.status == "some status"
      assert task.type == "some type"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workspace.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{cancelled_at: ~U[2021-09-01 19:29:00.000000Z], completed_at: ~U[2021-09-01 19:29:00.000000Z], description: "some updated description", generation: 43, started_at: ~U[2021-09-01 19:29:00.000000Z], status: "some updated status", type: "some updated type"}

      assert {:ok, %Task{} = task} = Workspace.update_task(task, update_attrs)
      assert task.cancelled_at == ~U[2021-09-01 19:29:00.000000Z]
      assert task.completed_at == ~U[2021-09-01 19:29:00.000000Z]
      assert task.description == "some updated description"
      assert task.generation == 43
      assert task.started_at == ~U[2021-09-01 19:29:00.000000Z]
      assert task.status == "some updated status"
      assert task.type == "some updated type"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Workspace.update_task(task, @invalid_attrs)
      assert task == Workspace.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Workspace.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Workspace.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Workspace.change_task(task)
    end
  end

  describe "results" do
    alias Example16.Workspace.Result

    import Example16.WorkspaceFixtures

    @invalid_attrs %{data: nil, description: nil, errors: nil, generation: nil, type: nil}

    test "list_results/0 returns all results" do
      result = result_fixture()
      assert Workspace.list_results() == [result]
    end

    test "get_result!/1 returns the result with given id" do
      result = result_fixture()
      assert Workspace.get_result!(result.id) == result
    end

    test "create_result/1 with valid data creates a result" do
      valid_attrs = %{data: %{}, description: "some description", errors: %{}, generation: 42, type: "some type"}

      assert {:ok, %Result{} = result} = Workspace.create_result(valid_attrs)
      assert result.data == %{}
      assert result.description == "some description"
      assert result.errors == %{}
      assert result.generation == 42
      assert result.type == "some type"
    end

    test "create_result/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workspace.create_result(@invalid_attrs)
    end

    test "update_result/2 with valid data updates the result" do
      result = result_fixture()
      update_attrs = %{data: %{}, description: "some updated description", errors: %{}, generation: 43, type: "some updated type"}

      assert {:ok, %Result{} = result} = Workspace.update_result(result, update_attrs)
      assert result.data == %{}
      assert result.description == "some updated description"
      assert result.errors == %{}
      assert result.generation == 43
      assert result.type == "some updated type"
    end

    test "update_result/2 with invalid data returns error changeset" do
      result = result_fixture()
      assert {:error, %Ecto.Changeset{}} = Workspace.update_result(result, @invalid_attrs)
      assert result == Workspace.get_result!(result.id)
    end

    test "delete_result/1 deletes the result" do
      result = result_fixture()
      assert {:ok, %Result{}} = Workspace.delete_result(result)
      assert_raise Ecto.NoResultsError, fn -> Workspace.get_result!(result.id) end
    end

    test "change_result/1 returns a result changeset" do
      result = result_fixture()
      assert %Ecto.Changeset{} = Workspace.change_result(result)
    end
  end

  describe "progress" do
    alias Example16.Workspace.Progress

    import Example16.WorkspaceFixtures

    @invalid_attrs %{completed: nil, description: nil, status: nil, total: nil}

    test "list_progress/0 returns all progress" do
      progress = progress_fixture()
      assert Workspace.list_progress() == [progress]
    end

    test "get_progress!/1 returns the progress with given id" do
      progress = progress_fixture()
      assert Workspace.get_progress!(progress.id) == progress
    end

    test "create_progress/1 with valid data creates a progress" do
      valid_attrs = %{completed: 42, description: "some description", status: "some status", total: 42}

      assert {:ok, %Progress{} = progress} = Workspace.create_progress(valid_attrs)
      assert progress.completed == 42
      assert progress.description == "some description"
      assert progress.status == "some status"
      assert progress.total == 42
    end

    test "create_progress/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workspace.create_progress(@invalid_attrs)
    end

    test "update_progress/2 with valid data updates the progress" do
      progress = progress_fixture()
      update_attrs = %{completed: 43, description: "some updated description", status: "some updated status", total: 43}

      assert {:ok, %Progress{} = progress} = Workspace.update_progress(progress, update_attrs)
      assert progress.completed == 43
      assert progress.description == "some updated description"
      assert progress.status == "some updated status"
      assert progress.total == 43
    end

    test "update_progress/2 with invalid data returns error changeset" do
      progress = progress_fixture()
      assert {:error, %Ecto.Changeset{}} = Workspace.update_progress(progress, @invalid_attrs)
      assert progress == Workspace.get_progress!(progress.id)
    end

    test "delete_progress/1 deletes the progress" do
      progress = progress_fixture()
      assert {:ok, %Progress{}} = Workspace.delete_progress(progress)
      assert_raise Ecto.NoResultsError, fn -> Workspace.get_progress!(progress.id) end
    end

    test "change_progress/1 returns a progress changeset" do
      progress = progress_fixture()
      assert %Ecto.Changeset{} = Workspace.change_progress(progress)
    end
  end
end

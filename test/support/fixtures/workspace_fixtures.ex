defmodule Example16.WorkspaceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Example16.Workspace` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        completed?: true,
        description: "some description",
        design_cost: "120.5",
        generation: 42,
        name: "some name",
        remaining: 42,
        type: "some type"
      })
      |> Example16.Workspace.create_project()

    project
  end

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        cancelled_at: ~U[2021-08-31 19:29:00.000000Z],
        completed_at: ~U[2021-08-31 19:29:00.000000Z],
        description: "some description",
        generation: 42,
        started_at: ~U[2021-08-31 19:29:00.000000Z],
        status: "some status",
        type: "some type"
      })
      |> Example16.Workspace.create_task()

    task
  end

  @doc """
  Generate a result.
  """
  def result_fixture(attrs \\ %{}) do
    {:ok, result} =
      attrs
      |> Enum.into(%{
        data: %{},
        description: "some description",
        errors: %{"0": %{
          message: "some message",
          path: "some path",
          phase: "some phase",
          system: false,
          fatal: true
        }},
        generation: 42,
        type: "some type"
      })
      |> Example16.Workspace.create_result()

    result
  end

  @doc """
  Generate a progress.
  """
  def progress_fixture(attrs \\ %{}) do
    {:ok, progress} =
      attrs
      |> Enum.into(%{
        completed: 42,
        description: "some description",
        status: "some status",
        total: 42
      })
      |> Example16.Workspace.create_progress()

    progress
  end
end

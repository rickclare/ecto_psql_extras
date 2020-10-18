defmodule EctoPSQLExtras.Calls do
  @behaviour EctoPSQLExtras

  def info do
    %{
      title: "10 queries that have the highest frequency of execution",
      limit: 10,
      order_by: [calls: :desc],
      columns: [
        %{name: :query, type: :string},
        %{name: :exec_time, type: :interval},
        %{name: :prop_exec_time, type: :percent},
        %{name: :calls, type: :integer},
        %{name: :sync_io_time, type: :interval}
      ]
    }
  end

  def query do
    """
    /* 10 queries that have the highest frequency of execution */

    SELECT query AS query,
    interval '1 millisecond' * total_exec_time AS exec_time,
    (total_exec_time/sum(total_exec_time) OVER())  AS exec_time_ratio,
    calls,
    interval '1 millisecond' * (blk_read_time + blk_write_time) AS sync_io_time
    FROM pg_stat_statements WHERE userid = (SELECT usesysid FROM pg_user WHERE usename = current_user LIMIT 1)
    ORDER BY calls DESC
    LIMIT 10;
    """
  end
end

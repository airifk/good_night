module Api
  module V1
    class FriendsSleepRecordsController < ApplicationController
      before_action :set_pagination, only: [:index]
      def index
        sql = <<-SQL
        WITH ranked_clock_in AS (
          SELECT
            id,
            user_id,
            clock_in_time,
            ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY clock_in_time) AS in_rank
          FROM sleep_records
          WHERE clock_in_time IS NOT NULL
        ),
        ranked_clock_out AS (
          SELECT
            id,
            user_id,
            clock_out_time,
            ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY clock_out_time) AS out_rank
          FROM sleep_records
          WHERE clock_out_time IS NOT NULL
        )
        SELECT
          ci.user_id,
          ci.clock_in_time,
          co.clock_out_time,
          EXTRACT(EPOCH FROM (co.clock_out_time - ci.clock_in_time)) AS duration
        FROM
          ranked_clock_in ci
        JOIN
          ranked_clock_out co
        ON
          ci.user_id = co.user_id AND ci.in_rank = co.out_rank
        WHERE
          ci.clock_in_time IS NOT NULL AND co.clock_out_time IS NOT NULL
        ORDER BY
          duration DESC
        LIMIT #{@per_page}
        OFFSET #{@offset};
        SQL

        follow_sleep_record = SleepRecord.find_by_sql(sql)
        render json: follow_sleep_record, status: :ok, each_serializer: FollowSleepRecordSerializer
      end

      private

      def set_pagination
        @per_page = params[:per_page] || 10
        @page = params[:page] || 1
        @offset = (@page.to_i - 1) * @per_page.to_i
      end
    end
  end
end
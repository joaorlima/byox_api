# defmodule ByoxApi.ContentMapper.DataMapper do

#   require Logger

#   def extract2(mapped_data) do
#     mapped_data
#     |> Enum.map(&extract_topics_and_tutorials/1)
#   end

#   defp extract_topics_and_tutorials({topic_data, tutorial_data}) do
#     case extract_topic_from_tag(topic_data) do
#       {:ok, topic} ->
#         tutorial =
#           tutorial_data
#           |> Enum.map(&parse_tag/1)
#         {:ok, {topic, tutorial}}
#       {:error, reason} -> {:error, nil}
#     end
#   end

#   def extract(topic_tag, html_tags) do
#     topic = extract_topic_from_tag(topic_tag)
#     tutorials = Enum.map(html_tags, &parse_tag/1)
#     {topic, tutorials}
#   end

#   defp extract_topic_from_tag(topic_tag) do
#     case Regex.run(~r{<a href="#[^>]+">(?<topic>[^<]+)</a>}, topic_tag,
#            capture: [:topic]
#          ) do
#       [topic] ->
#         {:ok, topic}
#       _ ->
#         Logger.info("Error")
#         {:error, :no_result}
#     end
#   end

#   defp parse_tag(tag) do
#     case Regex.run(
#            ~r{<a href="(?<url>[^"]+)"><strong>(?<language>[^<]+)</strong>: <em>(?<title>[^<]+)</em></a>},
#            tag,
#            capture: [:url, :language, :title]
#          ) do
#       [url, language, title] -> {:ok, %{url: url, language: language, title: title}}
#       _ -> {:error, nil}
#     end
#   end
# end

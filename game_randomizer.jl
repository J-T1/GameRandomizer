using DataFrames
using Random
using CSV
using DotEnv
DotEnv.load!()

function main()
    player = split.(ENV["PLAYER"], ",")
    games = split.(ENV["GAMES"], ",")
    max_player_per_game = 4

    num_of_players = Int(length(player))
    num_of_games = Int(length(games))

    num_of_groups = Int(round(num_of_players / max_player_per_game, RoundUp))

    extra_players = num_of_players % max_player_per_game

    player_per_game = []
    if extra_players != 0
        for i in 1:num_of_groups-(max_player_per_game-extra_players)
            push!(player_per_game, max_player_per_game)
        end
        for i in 1:max_player_per_game-extra_players
            push!(player_per_game, max_player_per_game - 1)
        end
    else
        for i in 1:num_of_groups
            push!(player_per_game, max_player_per_game)
        end
    end

    @info "The number of players is: " num_of_players
    @info "The number of games is: " num_of_games
    @info "The number of groups is: " num_of_groups
    @info "The number of players per game is: " player_per_game

    played_flag = zeros(num_of_players, num_of_games)
    output = fill("-", sum(player_per_game) + 1, num_of_games + 1)
    game_list = fill("-", num_of_groups + 1, num_of_games + 1)

    for group_id in 1:num_of_groups
        start_id = 0
        if group_id != 1
            start_id = sum(player_per_game[1:group_id-1])
        end
        for player_id in 1:player_per_game[group_id]
            output[start_id + player_id + 1, 1] = "Group " * string(group_id)
            game_list[group_id + 1, 1] = "Group " * string(group_id)
        end
    end

    while any(played_flag .== 0.0)
        player_list = []
        count = 0
        game_id = 0
        played_flag = zeros(num_of_players, num_of_games)

        for round_id in 1:num_of_games
            output[1, round_id + 1] = "Round " * string(round_id)
            game_list[1, round_id + 1] = "Round " * string(round_id)
            games_filtered = Vector{Int64}(1:num_of_games)
            player_in_round = Vector{Int64}(1:num_of_players)
            for group_id in 1:num_of_groups
                while count < player_per_game[group_id] && length(player_in_round) != count
                    if length(games_filtered) == 0
                        break
                    end
                    count = 0
                    game_id = rand(games_filtered)
                    deleteat!(games_filtered, findall(x -> x == game_id, games_filtered))
                    player_list = []
                    for player_id in shuffle(player_in_round)
                        if count == player_per_game[group_id]
                            break
                        end
                        if played_flag[player_id, game_id] == 0 && player_id in player_in_round
                            push!(player_list, player_id)
                            count += 1
                        end
                    end
                end
                start_id = 0
                if group_id != 1
                    start_id = sum(player_per_game[1:group_id-1])
                end
                count = 1
                for player_id in player_list
                    played_flag[player_id, game_id] = 1
                    deleteat!(player_in_round, findall(x -> x == player_id, player_in_round))
                    count += 1
                    output[start_id + count, round_id + 1] = player[player_id]
                    game_list[group_id+1, round_id +1] = games[game_id]
                end
                count = 0
                player_list = []
            end
        end
    end

    CSV.write("players.csv", DataFrame(output, :auto))
    CSV.write("games.csv", DataFrame(game_list, :auto))
end

main()
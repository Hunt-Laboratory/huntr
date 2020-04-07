
#' Generate plots for feedback reports to organisations
#'
#' \code{generate_feedback_plots} This function generates the graphs
#' that are to be used in the feedback reports to organisations 
#' following the completion of the 2020 Hunt Challenge.
#' 
#' The graphs will be generated as images in the 'exports' folder in
#' your R working directory. The images then need to be manually
#' inserted into the report template, which is a Google Doc. The 
#' template is called 'Organisation Feedback Template' and is stored
#' in the drive under:
#'   SWARM2_ALL
#'    > Hunt Challenge 2020
#'       > Reports to Organisations
#'
#' @export
#' 
#' @examples
#' \dontrun{
#' # (re-)compile data
#' generate_feedback_plots('2020_HuntChallenge')
#' }
generate_feedback_plots = function(instance_name) {
    
  teams = repo[[instance_name]]$OtherData$teams
  teams = as.character(teams[teams$isOrg,]$team)
  
  for (team_name in teams[7]) {
    message(team_name)
    # plots_demographic(instance_name, team_name, export = T)
    # plot_slopegraph(instance_name, team_name, export = T)
    # plot_team_dynamics(instance_name, team_name, export = T)
    plot_timeline(instance_name, team_name, export = T)
    # plot_qor_teamsize(instance_name, team_name, export = T)
    # plot_qor_AOMT(instance_name, team_name, export = T)
    # plot_qor_divAOMT(instance_name, team_name, export = T)
    # plot_qor_textSim(instance_name, team_name, export = T)
  }
    
}

export_plot = function(plot_object, file_name, instance_name, team_name, export_size = "A4") {
    
  # Define width and height based on requested size.
  widths = list(
      "A4" = 2181,
      "A4-title" = 2181,
      "A4-title-subtitle" = 2181,
      "(A4-title)/2" = 2181,
      "(A4-title)/2.5" = 2181,
      "(A4-title)/3" = 2181,
      "square" = 2181
  )
  heights = list(
      "A4" = 3000,
      "A4-title" = 2847,
      "A4-title-subtitle" = 2750,
      "(A4-title)/2" = 1700,
      "(A4-title)/2.5" = 1450,
      "(A4-title)/3" = 1200,
      "square" = 2300
  )
  w = widths[[export_size]]
  h = heights[[export_size]]
  
  # Export plot.
  wd = getwd()
  dir.create(file.path(wd, "exports"), showWarnings = F)
  dir.create(file.path(wd, "exports", instance_name), showWarnings = F)
  dir.create(file.path(wd, "exports", instance_name, team_name), showWarnings = F)
  setwd(file.path(wd, "exports", instance_name, team_name))
  ggexport(plot_object,
           filename = file_name,
           width = w,
           height = h,
           pointsize = 11,
           res = 300)
  setwd(wd)
}


plot_demographic = function (instance_name, team_name, dem) {
    
    parts = as.data.frame(repo[[instance_name]]$OtherData$parts)
    key = dem[["key"]]
    options = dem[["options"]]
    
    parts = parts[!is.na(parts[[key]]),]
    
    # Convert relevant demographic to factor.
    parts[[key]] = factor(parts[[key]], levels = options)
    
    nLevels = length(levels(parts[[key]]))
    Q = data.frame(key = rep(levels(parts[[key]]), 3),
                   group = c(rep("Your Team", nLevels),
                             rep("OT", nLevels),
                             rep("PT", nLevels)),
                   prop = numeric(3 * nLevels))
    
    for (k in 1:nrow(Q)) {
        if (Q$group[k] == "Your Team") {
            Q$prop[k] = nrow(parts[parts$team == team_name & as.character(parts[[key]]) == Q$key[k],]) / nrow(parts[parts$team == team_name,])
        } else if (Q$group[k] == "OT") {
            Q$prop[k] = nrow(parts[parts$isOrg & as.character(parts[[key]]) == Q$key[k],]) / nrow(parts[parts$isOrg,])
        } else if (Q$group[k] == "PT") {
            Q$prop[k] = nrow(parts[!parts$isOrg & as.character(parts[[key]]) == Q$key[k],]) / nrow(parts[!parts$isOrg,])
        }
    }
    Q$prop = 100*Q$prop
    
    if (key == "occupation") {
        ylab = "Percentage of Participants (%)"
    } else {
        ylab = ""
    }
    
    Q$group = factor(Q$group,
                     levels = c("PT",
                                "OT",
                                "Your Team"))
    p = ggplot(Q, aes(key, prop, fill = group)) +
        geom_col(data = Q[Q$group == "PT",], width = .3, alpha = .3,
                 position = position_nudge(-.25, 0)) +
        geom_segment(data = Q[Q$group == "PT",],
                     aes(xend = ..x.. - .15, yend = prop),
                     colour = "#00a087",
                     position = position_nudge(-.25, 0)) +
        geom_segment(data = Q[Q$group == "PT",],
                     aes(xend = ..x.. + .15, yend = prop),
                     colour = "#00a087",
                     position = position_nudge(-.25, 0)) +
        geom_col(data = Q[Q$group == "OT",], width = .3, alpha = .3,
                 position = position_nudge(0, 0)) +
        geom_segment(data = Q[Q$group == "OT",],
                     aes(xend = ..x.. - .15, yend = prop),
                     colour = "#3c5488") +
        geom_segment(data = Q[Q$group == "OT",],
                     aes(xend = ..x.. + .15, yend = prop),
                     colour = "#3c5488") +
        geom_col(data = Q[Q$group == "Your Team",], width = .3, alpha = .3,
                 position = position_nudge(.25, 0)) +
        geom_segment(data = Q[Q$group == "Your Team",],
                     aes(xend = ..x.. - .15, yend = prop),
                     colour = "#e64b35",
                     position = position_nudge(.25, 0)) +
        geom_segment(data = Q[Q$group == "Your Team",],
                     aes(xend = ..x.. + .15, yend = prop),
                     colour = "#e64b35",
                     position = position_nudge(.25, 0)) +
        scale_fill_manual(values = c("#00a087", "#3c5488", "#e64b35"),
                          breaks = levels(Q$group),
                          labels = levels(Q$group)) +
        scale_x_discrete(breaks = options,
                         labels = dem[["optionLabels"]]) +
        labs(title = dem[["label"]],
             x = NULL,
             y = ylab,
             fill = "Group") +
        theme_huntlab() +
        theme(panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
              panel.grid.minor.y = element_line(size = .5, colour = "#f6f6f6"),
              legend.position = "bottom",
              plot.margin = margin(0, 0, 5, 0, "pt"),
              plot.title = element_text(size = 10))
    
    return(p)
}


plots_demographic = function(instance_name, team_name, export = F) {
    
    # Define properties of demographic questions.
    dems = list(
        list(
            key = "agegroup",
            label = "Age Group",
            options =  c("Prefer not to say",
                         "18-25",
                         "26-35",
                         "36-45",
                         "46-55",
                         "56-65",
                         "over 65"),
            optionLabels =  c("Prefer not to say",
                              "18-25",
                              "26-35",
                              "36-45",
                              "46-55",
                              "56-65",
                              "over 65")
        ),
        list(
            key = "gender",
            label = "Gender",
            options =  c("Female",
                         "Male",
                         "Other",
                         "Prefer not to say"),
            optionLabels =  c("Female",
                              "Male",
                              "Other",
                              "Prefer not to say")
        ),
        list(
            key = "occupation",
            label = "Occupation",
            options =  c("Full Time Employment",
                         "Part time Employment",
                         "Full Time Student",
                         "Part Time Student",
                         "Self employed",
                         "Not working right now",
                         "Retired",
                         "Other/Prefer not to say"),
            optionLabels =  c("Full Time\nEmployment",
                              "Part time\nEmployment",
                              "Full Time\nStudent",
                              "Part Time\nStudent",
                              "Self employed",
                              "Not working\nright now",
                              "Retired",
                              "Other/\nPrefer not\nto say")
        ),
        list(
            key = "education",
            label = "Education Level",
            options =  c("High School",
                         "Trade or Technical Qualification",
                         "Bachelors",
                         "Graduate Certificate, Diploma or equivalent",
                         "Masters",
                         "Phd",
                         "Prefer not to say"),
            optionLabels =  c("High\nSchool",
                              "Trade or\nTechnical\nQualification",
                              "Bachelors",
                              "Graduate\nCertificate,\nDiploma,\nor equivalent",
                              "Masters",
                              "Phd",
                              "Prefer not\nto say")
        ),
        list(
            key = "studyarea",
            label = "Study Area",
            options =  c("Arts/Humanities",
                         "Business/Commerce",
                         "Economics",
                         "Engineering",
                         "Law",
                         "Mathematics",
                         "Politics",
                         "Social Science(s)",
                         "Other"),
            optionLabels =  c("Arts/\nHumanities",
                              "Business/\nCommerce",
                              "Economics",
                              "Engineering",
                              "Law",
                              "Mathematics",
                              "Politics",
                              "Social\nScience(s)",
                              "Other")
        )
    )
    
    # Construct plot.
    for (k in 1:length(dems)) {
        p = plot_demographic(instance_name,
                            team_name,
                            dems[[k]]
                            )
        if (k == 1) {
            pw = p
        } else {
            pw = pw / p
        }
    }
    
    pw = pw + plot_layout(guides = 'collect') +
        plot_annotation(
            title = 'DEMOGRAPHIC PROFILES',
            subtitle = 'Demographic profiles for Public Teams, Organisational Teams, and your own team.',
            theme = theme(plot.margin = margin(10, 10, 10, 10, "pt"),
                          plot.background = element_rect(fill = "#f6f6f6"),
                          plot.title = element_text(face = "bold",
                                                    colour = "#014085"),
                          legend.position = "bottom")
        )
    
    if (export) {
        export_plot(pw, "demographics.png", instance_name, team_name, "A4-title-subtitle")
    }
    
    return(pw)
}


plot_slopegraph = function(instance_name, team_name, export = F) {
    
    probteams = repo[[instance_name]]$OtherData$probteams
    probteams[probteams$team == team_name,]$type = "Your Team"
    
    p = ggplot(probteams[probteams$probNum < 3,], aes(probNum, avgODNI, group = team, colour = type, alpha = type, size = type, label = rankODNI)) +
        geom_line() +
        scale_x_continuous(breaks = 1:2) + 
        scale_colour_manual(breaks = c("PT","OT","Your Team"),
                            values = c("#00a087", "#3c5488", "#e64b35")) +
        scale_alpha_manual(breaks = c("PT","OT","Your Team"),
                           values = c(.4, 1, 1)) +
        scale_size_manual(breaks = c("PT","OT","Your Team"),
                          values = c(.5, .5, 2)) +
        geom_text(data = probteams[probteams$probNum == 1,], colour = "#000000", size = 2, alpha = 1, position = position_nudge(-.01, 0)) +
        geom_text(data = probteams[probteams$probNum == 2,], colour = "#000000", size = 2, alpha = 1, position = position_nudge(.01, 0)) +
        labs(title = "TEAM PERFORMANCE OVER TIME",
             subtitle = "Slopegraph of the quality of reasoning for each team across problems. The teams' rank in each\nproblem is indicated at the end of the lines.",
             x = "Problem",
             y = "Average Quality of Reasoning (ODNI)",
             colour = "Type",
             size = "Type",
             alpha = "Type") +
        theme_huntlab() +
        theme(panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
              panel.grid.minor.y = element_line(size = .5, colour = "#f6f6f6"),
              legend.position = "bottom",
              plot.margin = margin(10, 10, 10, 10, "pt"),
              plot.title = element_text(face = "bold",
                                        colour = "#014085"))
    
    if (export) {
        export_plot(p, "slopegraph.png", instance_name, team_name, "(A4-title)/2")
    }
    
    return(p)
}


plot_team_dynamics = function(instance_name, team_name, export = F) {
  
  avatarLookup = list(
    "bilby" = "Bilby",
    "blackcockatoo" = "BlackCockatoo",
    "blackswan" = "BlackSwan",
    "bluewhale" = "BlueWhale",
    "boobook" = "Boobook",
    "booroolong" = "Booroolong",
    "budgerigar" = "Budgerigar",
    "cassowary" = "Cassowary",
    "cockatoo" = "Cockatoo",
    "coorooboree" = "Coorooboree",
    "corella" = "Corella",
    "crocodile" = "Crocodile",
    "currawong" = "Currawong",
    "dingo" = "Dingo",
    "echidna" = "Echidna",
    "elephant" = "Elephant",
    "emu" = "Emu",
    "fairywren" = "FairyWren",
    "flyingfox" = "FlyingFox",
    "frogmouth" = "Frogmouth",
    "galah" = "Galah",
    "gecko" = "Gecko",
    "goanna" = "Goanna",
    "kangaroo" = "Kangaroo",
    "kiwi" = "Kiwi",
    "koala" = "Koala",
    "kookaburra" = "Kookaburra",
    "magpie" = "Magpie",
    "numbat" = "Numbat",
    "pademelon" = "Pademelon",
    "pharlap" = "PharLap",
    "platypus" = "Platypus",
    "pobblebonk" = "Pobblebonk",
    "possum" = "Possum",
    "quokka" = "Quokka",
    "quoll" = "Quoll",
    "sugarglider" = "SugarGlider",
    "swan" = "BlackSwan",
    "tassiedevil" = "TassieDevil",
    "thornydevil" = "ThornyDevil",
    "wallaby" = "Wallaby",
    "wallaroo" = "Wallaroo",
    "wombat" = "Wombat"
  )
  
  relations = repo[[instance_name]]$PlatformData$relations
  relations = relations[team == team_name]
  relations = relations[,.(weight = sum(count)), 
                        by = .(problem = problem,
                               team = team,
                               #"from" = pair_i(userName, addressant, 1),
                               #"to" = pair_i(userName, addressant, 2)
                               from = user,
                               to = addressant
                        )]
  parts = repo[[instance_name]]$OtherData$parts
  parts = parts[parts$team == team_name,]
  
  problems = c("Foreign Fighters",
               "Forecasting Piracy",
               "Corporate Espionage",
               "The Park Young-min Case")
  relations = relations[problem %in% problems & from %in% parts$user & to %in% parts$user]
  
  nodes = parts[,c("user","team")]
  colnames(nodes) = c("name", "team")
  edges = as.data.frame(relations[,-"team"])
  edges$problem = factor(edges$problem,
                         levels = problems)
  
  graph = tbl_graph(nodes = nodes, edges = edges)
  
  layout = create_layout(graph, layout = 'kk')
  
  p = ggraph(layout) +
    geom_edge_fan(aes(colour = weight,
                      alpha = stat(index)),
                  strength = 5,
                  edge_width = 1,
                  show.legend = T) + 
    scale_edge_alpha(guide = F) +
    #scale_edge_width(limits = c(1,22), guide = F) +
    # scale_edge_colour_distiller(limits = c(1,22),
    #                             type = "div",
    #                             palette = "Spectral",
    #                             name = "Interaction\nCount",
    #                             direction = -1) +
    # scale_edge_colour_gradientn(limits = c(1,22),
    #                             colours = c(
    #                               "#e3f2fd",
    #                               "#bbdefb",
    #                               "#9fa8da", # "#90caf9",
    #                               "#7986cb", # "#64b5f6",
    #                               "#7e57c2", # "#42a5f5",
    #                               "#9c27b0", # "#2196f3",
    #                               "#d81b60", # "#1e88e5",
    #                               "#c2185b", # "#1976d2",
    #                               "#c62828", # "#1565c0",
    #                               "#b71c1c"), # "#0d47a1"),
    #                             name = "Interaction\nCount") +
    scale_edge_colour_viridis(limits = c(1,22),
                              option = "viridis",
                              begin = 0,
                              end = 0.95,
                              name = "Interaction\nCount",
                              direction = -1) +
    geom_node_point(size = 5) +
    scale_x_continuous(expand = expansion(mult = .1)) +
    scale_y_continuous(expand = expansion(mult = .1)) +
    facet_edges(vars(problem),
                nrow = 2,
                ncol = 2,
                scales = "fixed",
                drop = F) +
    theme_huntlab()
  
  for (k in 1:nrow(layout)) {
    animal = avatarLookup[[sub("\\d+", "", layout$name[k])]]
    avtr = readPNG(paste0("/home/luke/Documents/Hunt Lab/wd_HuntLab/huntr/R/avatars/",animal,"@2x.png"))
    grb = rasterGrob(avtr, interpolate = T)
    x = layout$x[k]
    y = layout$y[k]
    p = p + annotation_custom(grb, xmin = x - 0.25, xmax = x + 0.25, ymin = y - 0.25, ymax = y + 0.25)
  }
  
  p = p + plot_layout(guides = 'collect') +
      plot_annotation(
          title = 'INTERACTION NETWORKS',
          subtitle = 'Interaction patterns for your team by problem. Each vertex is a user, labelled with their SWARM\nplatform avatar. Edges between vertices represent interactions between users, coloured by the\nnumber of interactions.',
          theme = theme(plot.margin = margin(10, 10, 10, 10, "pt"),
                        plot.background = element_rect(fill = "#f6f6f6"),
                        plot.title = element_text(face = "bold",
                                                  colour = "#014085"))
      )
  
  if (export) {
      export_plot(p,
                  "team_dynamics.png",
                  instance_name,
                  team_name,
                  "square")
  }

}


plot_team_dynamics_comparison = function(instance_name, team_name, export = F) {
    
  # pairUp = function(v1, v2) {
  #   rval = c()
  #   for (k in 1:length(v1)) {
  #     rval = c(rval, paste(c(v1[k],v2[k])[order(c(v1[k],v2[k]))], collapse = "-"))
  #   }
  #   return(rval)
  # }
  # pair_i = function(v1, v2, i) {
  #   rval = c()
  #   for (k in 1:length(v1)) {
  #     rval = c(rval, c(v1[k],v2[k])[order(c(v1[k],v2[k]))][i])
  #   }
  #   return(rval)
  # }
  
  relations = repo[[instance_name]]$PlatformData$relations
  relations = relations[,.(weight = sum(count)), 
                        by = .(problem = problem,
                               team = team,
                               #"from" = pair_i(userName, addressant, 1),
                               #"to" = pair_i(userName, addressant, 2)
                               from = user,
                               to = addressant
                        )]
  
  teams = as.character(repo[[instance_name]]$OtherData$teams$team)
  problems = c("Drug Interdiction",
               "Forecasting Piracy")
  relations = relations[problem %in% problems]
  plots = list()
  
  for (k in 1:length(teams[1:6])) {
      tm = teams[k]
      nodes = unique(rbind(relations[team == tm,team,by = .("name" = to)], relations[team == tm][,team,by = .("name" = from)]))
      edges = as.data.frame(relations[team == tm,-"team"])
      edges$problem = factor(edges$problem,
                             levels = problems)
      
      graph = tbl_graph(nodes = nodes, edges = edges)
      
      plots[[k]] = ggraph(graph, layout = 'kk') + 
          geom_edge_fan(aes(colour = weight,
                            alpha = stat(index)),
                        strength = 5,
                        edge_width = 1,
                        show.legend = T) + 
          scale_edge_alpha(guide = F) +
          #scale_edge_width(limits = c(1,22), guide = F) +
          scale_edge_colour_distiller(limits = c(1,22),
                                      type = "div",
                                      palette = "Spectral",
                                      name = "Interaction\nCount",
                                      direction = -1) +
          geom_node_point(size = 1) +
          scale_x_continuous(expand = expansion(mult = .1)) +
          scale_y_continuous(expand = expansion(mult = .1)) +
          facet_graph(team ~ problem,
                      row_type = "node",
                      col_type = "edge",
                      scales = "free_y",
                      space = "fixed",
                      switch = "y",
                      drop = F) +
          theme_huntlab()
      
      if (k == 1) {
          plots[[k]] = plots[[k]]
          pw = plots[[k]]
      }
      
      if (k > 1) {
          plots[[k]] = plots[[k]] + theme(strip.text.x = element_blank())
          pw = pw / plots[[k]]
      }
  }

  pw = pw + plot_layout(guides = 'collect') +
      plot_annotation(
          title = 'INTERACTION NETWORKS',
          subtitle = 'Interaction patterns by team (rows) and problem (columns). Each vertex is a user. Edges between\nvertices represent interactions between users, coloured by the number of interactions.',
          theme = theme(plot.margin = margin(10, 10, 10, 10, "pt"),
                        plot.background = element_rect(fill = "#f6f6f6"),
                        plot.title = element_text(face = "bold",
                                                  colour = "#014085"))
      )
  
  if (export) {
      export_plot(pw,
                  "team_dynamics.png",
                  instance_name,
                  team_name,
                  "A4")
  }

}


plot_timeline = function(instance_name, team_name, export = F) {
    
  timeline = repo[[instance_name]]$PlatformData$timeline
  
  teams = unique(timeline$team)
  problems = unique(timeline$problem)

  D = as.data.frame(timeline)
  D = D[D$team == team_name,]

  closeDates = list(
    "Foreign Fighters" = "2020-02-26 17:00",
    "Forecasting Piracy" = "2020-03-04 17:00",
    "Corporate Espionage" = "2020-03-18 17:00",
    "The Park Young-min Case" = "2020-03-27 17:00"
    # "Drug Interdiction" = "2018-07-25 19:00",
    # "Kalukistan" = "2018-07-11 19:00",
    # "How Did Arthur Allen Die?" = "2018-07-04 19:00",
    # "Three Nations" = "2018-07-18 19:00"
  )

  D$time = NA
  for (k in 1:nrow(D)) {
    D$time[k] = suppressMessages(
      int_length(interval(
        ymd_hms(D$timeStamp[k], tz = "Australia/Melbourne"),
        ymd_hm(closeDates[[D$problem[k]]], tz = "Australia/Melbourne")
      ))/(60*60*24)
    )
  }
  D$timeStamp = as.POSIXct(D$timeStamp, tz = "Australia/Melbourne")

  plots = list()

  for (k in 1:length(problems)) {
    
    plots[[k]] = ggplot(data=D[D$problem == problems[k],], aes(x=time, group=type, fill=type)) +
      geom_density(bw = .1,
                   linetype = 0,
                   position = "stack",
                   kernel = "gaussian") +
      scale_fill_manual(breaks = c("resource", "report", "update", "comment", "rating"),
                        values = c("#de5f4d", "#5db8cd", "#20a08b", "#435887", "#e9b8ab"),
                        drop = F) +
      labs(title = problems[k],
           x = "Days before problem closed",
           y = NULL,
           fill = "Activity\nType") +
      scale_x_reverse(breaks = 0:7, expand = c(0, 0), limits = c(7,0)) +
      scale_y_continuous(expand = expansion(mult = c(0, .1), add = c(0, 0))) +
      theme_huntlab() +
      theme(axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            panel.spacing = unit(10, "pt"),
            panel.grid.major.x = element_line(color = "#f6f6f6", size = 1),
            panel.grid.minor.x = element_line(color = "#f6f6f6", size = .5),
            panel.grid.major.y = element_blank(),
            panel.grid.minor.y = element_blank(),
            plot.title = element_text(color = "#014085", size = unit(11, "pt")),
            plot.margin = margin(5, 0, 0, 0, "pt"))
    
    if (k < 4) {
      plots[[k]] = plots[[k]] + theme(
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank()
      )
    }
    
    if (k == 1) {
      pw = plots[[k]]
    }
    
    if (k > 1) {
      pw = pw / plots[[k]]
    }
  }

  pw = pw + plot_layout(guides = 'collect') +
    plot_annotation(
      title = 'ACTIVITY TIMELINES',
      subtitle = 'Activity timelines by problem for your team. Activity is coloured by type.',
      theme = theme(plot.margin = margin(11, 10, 10, 8, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )

  if (export) {
      export_plot(pw,
                  "timeline.png",
                  instance_name,
                  team_name,
                  "(A4-title)/2.5")
      
  }
    
}


plot_timeline_reference = function(export = F) {
  
  timeline = repo[[instance_name]]$PlatformData$timeline
  D = as.data.frame(timeline)
  
  closeDates = list(
    "Foreign Fighters" = "2020-02-26 17:00",
    "Forecasting Piracy" = "2020-03-04 17:00",
    "Corporate Espionage" = "2020-03-18 17:00",
    "The Park Young-min Case" = "2020-03-27 17:00"
  )
  
  D$time = NA
  for (k in 1:nrow(D)) {
    D$time[k] = suppressMessages(
      int_length(interval(
        ymd_hms(D$timeStamp[k], tz = "Australia/Melbourne"),
        ymd_hm(closeDates[[D$problem[k]]], tz = "Australia/Melbourne")
      ))/(60*60*24)
    )
  }
  D$timeStamp = as.POSIXct(D$timeStamp, tz = "Australia/Melbourne")
  
  D$type = factor(D$type,
                  levels = c("resource",
                             "report",
                             "update",
                             "comment",
                             "rating"))
  
  plots = list()
  
    plots[[1]] = ggplot(data = D, aes(x = time, group = type, fill = type)) +
      geom_density(bw = .1,
                   linetype = 0,
                   position = "stack",
                   kernel = "gaussian") +
      scale_fill_manual(breaks = c("resource", "report", "update", "comment", "rating"),
                        values = c("#de5f4d", "#5db8cd", "#20a08b", "#435887", "#e9b8ab"),
                        drop = F) +
      labs(title = "Aggregation of all teams and problems",
           x = "Days before problem closed",
           y = NULL,
           fill = "Activity\nType") +
      scale_x_reverse(breaks = 0:7, expand = c(0, 0), limits = c(7,0)) +
      scale_y_continuous(expand = expansion(mult = c(0, .1), add = c(0, 0))) +
      theme_huntlab() +
      theme(axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            panel.spacing = unit(10, "pt"),
            panel.grid.major.x = element_line(color = "#f6f6f6", size = 1),
            panel.grid.minor.x = element_line(color = "#f6f6f6", size = .5),
            panel.grid.major.y = element_blank(),
            panel.grid.minor.y = element_blank(),
            plot.title = element_text(color = "#014085", size = unit(11, "pt")),
            plot.margin = margin(5, 0, 0, 0, "pt"))
    
    plots[[1]] = plots[[1]] + theme(
      axis.ticks.x = element_blank(),
      axis.text.x = element_blank(),
      axis.title.x = element_blank()
    )
    
    plots[[2]] = ggplot(data = D[D$team == "tongariro00311" & D$problem == "Corporate Espionage", ], aes(x = time, group = type, fill = type)) +
      geom_density(bw = .1,
                   linetype = 0,
                   position = "stack",
                   kernel = "gaussian") +
      scale_fill_manual(breaks = c("resource", "report", "update", "comment", "rating"),
                        values = c("#de5f4d", "#5db8cd", "#20a08b", "#435887", "#e9b8ab"),
                        drop = F) +
      labs(title = "High-performing team (tongariro00311, 'Corporate Espionage')",
           x = "Days before problem closed",
           y = NULL,
           fill = "Activity\nType") +
      scale_x_reverse(breaks = 0:7, expand = c(0, 0), limits = c(7,0)) +
      scale_y_continuous(expand = expansion(mult = c(0, .1), add = c(0, 0))) +
      theme_huntlab() +
      theme(axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            panel.spacing = unit(10, "pt"),
            panel.grid.major.x = element_line(color = "#f6f6f6", size = 1),
            panel.grid.minor.x = element_line(color = "#f6f6f6", size = .5),
            panel.grid.major.y = element_blank(),
            panel.grid.minor.y = element_blank(),
            plot.title = element_text(color = "#014085", size = unit(11, "pt")),
            plot.margin = margin(5, 0, 0, 0, "pt"))
    
    plots[[2]] = plots[[2]] + theme(
      axis.ticks.x = element_blank(),
      axis.text.x = element_blank(),
      axis.title.x = element_blank()
    )
    
    plots[[3]] = ggplot(data = D[D$team == "bogong00219" & D$problem == "Forecasting Piracy", ], aes(x = time, group = type, fill = type)) +
      geom_density(bw = .1,
                   linetype = 0,
                   position = "stack",
                   kernel = "gaussian") +
      scale_fill_manual(breaks = c("resource", "report", "update", "comment", "rating"),
                        values = c("#de5f4d", "#5db8cd", "#20a08b", "#435887", "#e9b8ab"),
                        drop = F) +
      labs(title = "Low-performing team (bogong00219, 'Forecasting Piracy')",
           x = "Days before problem closed",
           y = NULL,
           fill = "Activity\nType") +
      scale_x_reverse(breaks = 0:7, expand = c(0, 0), limits = c(7,0)) +
      scale_y_continuous(expand = expansion(mult = c(0, .1), add = c(0, 0))) +
      theme_huntlab() +
      theme(axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            panel.spacing = unit(10, "pt"),
            panel.grid.major.x = element_line(color = "#f6f6f6", size = 1),
            panel.grid.minor.x = element_line(color = "#f6f6f6", size = .5),
            panel.grid.major.y = element_blank(),
            panel.grid.minor.y = element_blank(),
            plot.title = element_text(color = "#014085", size = unit(11, "pt")),
            plot.margin = margin(5, 0, 0, 0, "pt"))
    
  pw = plots[[1]] / plots[[2]] / plots[[3]]
  
  pw = pw + plot_layout(guides = 'collect') +
    plot_annotation(
      title = 'COMPARISON TIMELINES',
      subtitle = 'Three comparison timelines, provided for context. Note that the timelines show only the distribution of\ndifferent activity types over time. The quantity of activity is not comparable across timelines (that is, the\nscale of the y-axis differs between timelines).',
      theme = theme(plot.margin = margin(11, 10, 10, 8, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(pw,
                "reference_timeline.png",
                instance_name,
                team_name,
                "(A4-title)/2.5")
    
  }
  
}


plot_qor_teamsize = function(instance_name, team_name, export = F) {
  
  probteams = repo[[instance_name]]$OtherData$probteams
  probteams = probteams[!is.na(probteams$avgODNI),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  probteams$activeUsers = sqrt(probteams$activeUsersSq)
  
  p = ggplot(probteams, aes(x = activeUsers, y = avgODNI)) +
    stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
                colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    scale_colour_manual(breaks = c("PT","OT","Your Team"),
                        values = c("#00a087", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","OT","Your Team"),
                        values = c(1, 1, 3)) +
    labs(x = "Number of Active Users",
         y = "Average ODNI",
         colour = "Type",
         size = "Type") +
    theme_huntlab() +
    theme(panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6")
          )
  
  p = p + plot_layout(guides = 'collect') +
    plot_annotation(
      title = 'QOR v. TEAM SIZE',
      subtitle = 'Scatterplot of quality of reasoning scores (average ODNI) against number of active team members.\nThere is one point for each instance of a team participating in a problem. A quadratic regression line\nand 95% confidence interval (in yellow) is overlaid on the plot.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
      export_plot(p,
                  "qor_v_teamsize.png",
                  instance_name,
                  team_name,
                  "(A4-title)/3")
  }

}


plot_qor_AOMT = function(instance_name, team_name, export = F) {
  
  probteams = repo[[instance_name]]$OtherData$probteams
  probteams$team = as.character(probteams$team)
  teams = repo[[instance_name]]$OtherData$teams
  probteams = probteams[!is.na(probteams$avgODNI),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  probteams$AOMT = NA
  for (k in 1:nrow(probteams)) {
    probteams$AOMT[k] = teams[teams$team == probteams$team[k],]$AOMT[1]
  }
  
  
  p = ggplot(probteams, aes(x = AOMT, y = avgODNI)) +
    stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
                colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    scale_colour_manual(breaks = c("PT","OT","Your Team"),
                        values = c("#00a087", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","OT","Your Team"),
                        values = c(1, 1, 3)) +
    labs(x = "Actively Open-Minded Thinking",
         y = "Average ODNI",
         colour = "Type",
         size = "Type") +
    theme_huntlab() +
    theme(panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6")
          )
  
  p = p + plot_layout(guides = 'collect') +
    plot_annotation(
      title = 'QOR v. ACTIVELY OPEN-MINDED THINKING (AOMT)',
      subtitle = 'Scatterplot of quality of reasoning scores (average ODNI) against median AOMT score of team members.\nThere is one point for each instance of a team participating in a problem. A quadratic regression line\nand 95% confidence interval (in yellow) is overlaid on the plot.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
      export_plot(p,
                  "qor_v_AOMT.png",
                  instance_name,
                  team_name,
                  "(A4-title)/3")
  }

}


plot_qor_divAOMT = function(instance_name, team_name, export = F) {
  
  probteams = repo[[instance_name]]$OtherData$probteams
  probteams$team = as.character(probteams$team)
  teams = repo[[instance_name]]$OtherData$teams
  probteams = probteams[!is.na(probteams$avgODNI),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  probteams$divAOMT = NA
  for (k in 1:nrow(probteams)) {
    probteams$divAOMT[k] = teams[teams$team == probteams$team[k],]$divAOMT[1]
  }
  
  
  p = ggplot(probteams, aes(x = divAOMT, y = avgODNI)) +
    stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
                colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    scale_colour_manual(breaks = c("PT","OT","Your Team"),
                        values = c("#00a087", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","OT","Your Team"),
                        values = c(1, 1, 3)) +
    labs(x = "Actively Open-Minded Thinking",
         y = "Average ODNI",
         colour = "Type",
         size = "Type") +
    theme_huntlab() +
    theme(panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6")
          )
  
  p = p + plot_layout(guides = 'collect') +
    plot_annotation(
      title = 'QOR v. AOMT DIVERSITY',
      subtitle = 'Scatterplot of quality of reasoning scores (average ODNI) against diversity of AOMT among team\nmembers. There is one point for each instance of a team participating in a problem. A quadratic\nregression line and 95% confidence interval (in yellow) is overlaid on the plot.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
      export_plot(p,
                  "qor_v_divAOMT.png",
                  instance_name,
                  team_name,
                  "(A4-title)/3")
  }

}


plot_qor_textSim = function(instance_name, team_name, export = F) {
  
  probteams = repo[[instance_name]]$OtherData$probteams
  probteams = probteams[!is.na(probteams$avgODNI),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  
  p = ggplot(probteams, aes(x = textSim, y = avgODNI)) +
    stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
                colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    scale_colour_manual(breaks = c("PT","OT","Your Team"),
                        values = c("#00a087", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","OT","Your Team"),
                        values = c(1, 1, 3)) +
    labs(x = "Number of Active Users",
         y = "Average ODNI",
         colour = "Type",
         size = "Type") +
    theme_huntlab() +
    theme(panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6")
          )
  
  p = p + plot_layout(guides = 'collect') +
    plot_annotation(
      title = 'QOR v. TEXT SIMILARITY',
      subtitle = 'Scatterplot of quality of reasoning scores (average ODNI) against text similarity amongst a teams\nreports produced for a given problem. There is one point for each instance of a team participating\nin a problem. A quadratic regression line and 95% confidence interval (in yellow) is overlaid on the plot.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
      export_plot(p,
                  "qor_v_textSim.png",
                  instance_name,
                  team_name,
                  "(A4-title)/3")
  }

}

plot_probability_estimates = function(instance_name, team_name, export = F) {
  
  probteams = repo[[instance_name]]$OtherData$probteams
  probteams = probteams[!is.na(probteams$avgODNI) & !is.na(probteams$probabilityEstimate),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  
  p = ggplot(probteams, aes(x = probabilityEstimate)) +
    geom_histogram() +
    labs(x = "Probability Estimates",
         y = "Count") +
    theme_huntlab() +
    theme(panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.y = element_line(size = .5, colour = "#f6f6f6")
    )
  
  p = p + plot_layout(guides = 'collect') +
    plot_annotation(
      title = 'QOR v. TEXT SIMILARITY',
      subtitle = 'Scatterplot of quality of reasoning scores (average ODNI) against text similarity amongst a teams\nreports produced for a given problem. There is one point for each instance of a team participating\nin a problem. A quadratic regression line and 95% confidence interval (in yellow) is overlaid on the plot.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "qor_v_textSim.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}
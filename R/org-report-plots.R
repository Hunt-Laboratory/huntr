
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
  
  library(ggpubr)
  
  teams = as.data.frame(repo[[instance_name]]$CoreData$teams)
  teams = as.character(teams[teams$type == 'OT',]$team)
  
  for (team_name in teams[1]) {
    message(team_name)
    # plots_demographic(instance_name, team_name, export = T)
    # plot_slopegraph(instance_name, team_name, export = T)
    # plot_network(instance_name, team_name, export = T)
    # plot_network_reference(instance_name, team_name, export = T)
    # plot_timeline(instance_name, team_name, export = T)
    # # plot_timeline_reference(instance_name, team_name, export = T)
    # plot_qor_teamsize(instance_name, team_name, export = T)
    # plot_qor_activity(instance_name, team_name, export = T)
    # plot_qor_education(instance_name, team_name, export = T)
    # plot_qor_AOMT(instance_name, team_name, export = T)
    # plot_qor_divAOMT(instance_name, team_name, export = T)
    # plot_qor_textSim(instance_name, team_name, export = T)
    # plot_qor_nGeoCorrect(instance_name, team_name, export = T)
    # plot_qor_forecasting(instance_name, team_name, export = T)
    # plot_qor_tightness(instance_name, team_name, export = T)
    # plot_qor_nBayesCorrect(instance_name, team_name, export = T)
    # plot_qor_nFlawsDetected(instance_name, team_name, export = T)
    # plot_dot_qor(instance_name, team_name, export = T)
    # plot_qor_subscales(instance_name, team_name, export = T)
    # plot_dot_aggregated_performance(instance_name, team_name, export = T)
    # plot_dot_engagement(instance_name, team_name, export = T)
    # plot_dot_engagement_user(instance_name, team_name, export = T)
    # plot_dot_geolocation(instance_name, team_name, export = T)
    plot_dot_probability(instance_name, team_name, export = T)
    # plot_dot_brier(instance_name, team_name, export = T)
    # plot_redaction_estimates(instance_name, team_name, export = T)
    # plot_dot_tightness(instance_name, team_name, export = T)
    # plot_dot_bayes(instance_name, team_name, export = T)
    # plot_dot_flawdetection(instance_name, team_name, export = T)
    # # plot_cluster_stripchart(instance_name, team_name, e xport = T)
    # plot_user_engagement(instance_name, team_name, export = T)
    # plot_bar_expectations(instance_name, team_name, export = T)
    # plot_bar_capabilities(instance_name, team_name, export = T)
    # plot_bar_platform(instance_name, team_name, export = T)
    # plot_bar_challenge(instance_name, team_name, export = T)
    # plot_bar_CA(instance_name, team_name, export = T)
    # plot_bar_swarm(instance_name, team_name, export = T)
    # plot_qor_boxplot(instance_name, team_name, export = T)
  }
    
}

export_plot = function(plot_object, file_name, instance_name, team_name, export_size = "A4", plot_object_type = "ggplot") {
    
  # Define width and height based on requested size.
  widths = list(
      "A4" = 2181,
      "A4-title" = 2181,
      "A4-title-subtitle" = 2181,
      "(A4-title)/2" = 2181,
      "(A4-title)/2.5" = 2181,
      "(A4-title)/3" = 2181,
      "(A4-title)/3.5" = 2181,
      "(A4-title)/3.8" = 2181,
      "(A4-title)/4" = 2181,
      "square" = 2181
  )
  heights = list(
      "A4" = 2800,
      "A4-title" = 2747,
      "A4-title-subtitle" = 2600,
      "(A4-title)/2" = 1650,
      "(A4-title)/2.5" = 1420,
      "(A4-title)/3" = 1180,
      "(A4-title)/3.5" = 1000,
      "(A4-title)/3.8" = 930,
      "(A4-title)/4" = 600,
      "square" = 2250
  )
  w = widths[[export_size]]
  h = heights[[export_size]]
  
  # Export plot.
  wd = getwd()
  dir.create(file.path(wd, "exports"), showWarnings = F)
  dir.create(file.path(wd, "exports", instance_name), showWarnings = F)
  dir.create(file.path(wd, "exports", instance_name, team_name), showWarnings = F)
  setwd(file.path(wd, "exports", instance_name, team_name))
  if (plot_object_type == 'ggplot') {
    ggexport(plot_object,
             filename = file_name,
             width = w,
             height = h,
             pointsize = 11,
             res = 300)
  } else if (plot_object_type == 'grob') {
    ggsave(plot = plot_object,
           filename = file_name,
           width = w/300,
           height = h/300,
           units = 'in',
           dpi = 300)
  }
  setwd(wd)
}


plot_demographic_old = function (instance_name, team_name, dem) {
    
    parts = as.data.frame(repo[[instance_name]]$CoreData$parts)
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
        ylab = "% Participants"
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

plot_demographic = function (instance_name, team_name, dem) {
  
  parts = as.data.frame(repo[[instance_name]]$CoreData$parts)
  teamparts = as.data.frame(repo[[instance_name]]$CoreData$teamparts)
  teams = as.data.frame(repo[[instance_name]]$CoreData$teams)
  
  teamparts = setDT(merge(teamparts, teams, by = c('team'), all.x = T))
  teamparts = teamparts[,.(team, user, type)]
  
  parts = merge(parts, teamparts, by = c('user'), all.y = T)
  parts = as.data.frame(parts)
  
  key = dem[["key"]]
  options = dem[["options"]]
  
  parts = parts[!is.na(parts[[key]]),]
  
  # Convert relevant demographic to factor.
  parts[[key]] = factor(parts[[key]], levels = options)
  
  nLevels = length(levels(parts[[key]]))
  Q = data.frame(key = rep(levels(parts[[key]]), 4),
                 group = c(rep("PT", nLevels),
                           rep("ST", nLevels),
                           rep("OT", nLevels),
                           rep("Your Team", nLevels)),
                 prop = numeric(4 * nLevels))
  
  for (k in 1:nrow(Q)) {
    if (Q$group[k] == "Your Team") {
      Q$prop[k] = nrow(parts[parts$team == team_name & as.character(parts[[key]]) == Q$key[k],]) / nrow(parts[parts$team == team_name,])
    } else if (Q$group[k] == "OT") {
      Q$prop[k] = nrow(parts[parts$type == 'OT' & as.character(parts[[key]]) == Q$key[k],]) / nrow(parts[parts$type == 'OT',])
    } else if (Q$group[k] == "PT") {
      Q$prop[k] = nrow(parts[!parts$type == 'PT' & as.character(parts[[key]]) == Q$key[k],]) / nrow(parts[!parts$type == 'PT',])
    } else if (Q$group[k] == "ST") {
      Q$prop[k] = nrow(parts[!parts$type == 'ST' & as.character(parts[[key]]) == Q$key[k],]) / nrow(parts[!parts$type == 'ST',])
    }
  }
  Q$prop = 100*Q$prop
  
  if (key == "occupation") {
    ylab = "% Participants"
  } else {
    ylab = ""
  }
  
  Q$group = factor(Q$group,
                   levels = c("PT",
                              "ST",
                              "OT",
                              "Your Team"))
  p = ggplot(Q, aes(key, prop, fill = group)) +
    geom_col(position = position_dodge(preserve = 'total')) +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_x_discrete(breaks = options,
                     labels = dem[["optionLabels"]]) +
    labs(title = dem[["label"]],
         x = NULL,
         y = ylab,
         fill = "Type") +
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
    
    probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
    probteams[probteams$team == team_name,]$type = "Your Team"
    probteams = probteams[probteams$avgIC > 0,]
    
    p = ggplot(probteams, aes(probNum, avgIC, group = team, colour = type, alpha = type, size = type, label = rankIC)) +
        geom_line() +
        scale_x_continuous(breaks = 1:4) + 
        scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                            values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
        scale_alpha_manual(breaks = c("PT","ST","OT","Your Team"),
                           values = c(.4, .4, 1, 1)) +
        guides(colour = guide_legend(override.aes = list(alpha = 1))) +
        scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                          values = c(.5, .5, .5, 1.5)) +
        geom_label(data = probteams[probteams$probNum == 1,],
                  colour = "#000000",
                  size = 2,
                  alpha = 0.8,
                  label.padding = unit(0.1, "lines"),
                  label.r = unit(0.2, "lines"),
                  label.size = 0) +
        geom_label(data = probteams[probteams$probNum == 2,],
                  colour = "#000000",
                  size = 2,
                  alpha = 0.8,
                  label.padding = unit(0.1, "lines"),
                  label.r = unit(0.2, "lines"),
                  label.size = 0) +
        geom_label(data = probteams[probteams$probNum == 3,],
                   colour = "#000000",
                   size = 2,
                   alpha = 0.8,
                   label.padding = unit(0.1, "lines"),
                   label.r = unit(0.2, "lines"),
                   label.size = 0) +
        geom_label(data = probteams[probteams$probNum == 4,],
                  colour = "#000000",
                  size = 2,
                  alpha = 0.8,
                  label.padding = unit(0.1, "lines"),
                  label.r = unit(0.2, "lines"),
                  label.size = 0) +
        labs(title = "TEAM PERFORMANCE OVER TIME",
             subtitle = "Slopegraph of the quality of reasoning for each team across problems. Each line is a team,\ncoloured by type. The teams' rank in each problem is indicated at the end of the lines.",
             x = "Problem",
             y = "Average Quality of Reasoning (IC Rating Scale)",
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


plot_network = function(instance_name, team_name, export = F) {
  
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
  parts = as.data.frame(repo[[instance_name]]$CoreData$parts)
  teamparts = as.data.frame(repo[[instance_name]]$CoreData$teamparts)
  parts = merge(parts,teamparts,by = c('user'), all.y = T)
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
    geom_node_point(size = 1) +
    scale_x_continuous(expand = expansion(mult = .1)) +
    scale_y_continuous(expand = expansion(mult = .1)) +
    facet_edges(vars(problem),
                nrow = 2,
                ncol = 2,
                scales = "fixed",
                drop = F) +
    theme_huntlab()
  
  # for (k in 1:nrow(layout)) {
  #   animal = avatarLookup[[sub("\\d+", "", layout$name[k])]]
  #   avtr = readPNG(paste0("/home/luke/Documents/Hunt Lab/wd_HuntLab/huntr/R/avatars/",animal,"@2x.png"))
  #   grb = rasterGrob(avtr, interpolate = T)
  #   x = layout$x[k]
  #   y = layout$y[k]
  #   p = p + annotation_custom(grb, xmin = x - 0.25, xmax = x + 0.25, ymin = y - 0.25, ymax = y + 0.25)
  # }
  
  # p = p + geom_node_label(aes(label = name),
  #                         size = 1.8,
  #                         fill = "#f6f6f6",
  #                         alpha = .4,
  #                         label.size = 0,
  #                         label.padding = unit(0, "lines"),
  #                         label.r = unit(0, "lines"),
  #                         nudge_y = -.4)
  
  p = p + plot_layout(guides = 'collect') +
      plot_annotation(
          title = 'INTERACTION NETWORKS',
          subtitle = 'Interaction patterns for your team by problem. Each vertex is a user, labelled with their SWARM\nplatform avatar. Edges between vertices represent interactions between users, coloured by the\nnumber of interactions. Interactions are directional, so there may be two edges between any pair of users.',
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
                  "(A4-title)/2")
  }

}

plot_network_reference = function(instance_name, team_name, export = F) {
  
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
  relations = relations[
    (team == 'tongariro00311' & problem == 'Corporate Espionage') | 
      (team == 'bogong00219' & problem == 'Forecasting Piracy')
    ]
  relations = relations[,.(weight = sum(count)), 
                        by = .(problem = problem,
                               team = team,
                               #"from" = pair_i(userName, addressant, 1),
                               #"to" = pair_i(userName, addressant, 2)
                               from = user,
                               to = addressant
                        )]
  parts = as.data.frame(repo[[instance_name]]$CoreData$parts)
  teamparts = as.data.frame(repo[[instance_name]]$CoreData$teamparts)
  parts = merge(parts,teamparts,by = c('user'), all.y = T)
  parts = parts[parts$team %in% c('tongariro00311', 'bogong00219'),]
  
  problems = c("Corporate Espionage",
               "Forecasting Piracy")
  relations = relations[problem %in% problems & from %in% parts$user & to %in% parts$user]
  
  nodes = parts[,c("user","team")]
  colnames(nodes) = c("name", "team")
  edges = as.data.frame(relations[,-"team"])
  edges[edges$problem == 'Corporate Espionage',]$problem = 'High-performing team\n(tongariro00311, \'Corporate Espionage\')'
  edges[edges$problem == 'Forecasting Piracy',]$problem = 'Low-performing team\n(bogong00219, \'Forecasting Piracy\')'
  edges$problem = factor(edges$problem,
                         levels = c('High-performing team\n(tongariro00311, \'Corporate Espionage\')',
                                    'Low-performing team\n(bogong00219, \'Forecasting Piracy\')'))
  
  
  graph1 = tbl_graph(nodes = nodes[nodes$team == 'tongariro00311',], edges = edges[edges$problem == levels(edges$problem)[1],])
  layout1 = create_layout(graph1, layout = 'kk')
  
  graph2 = tbl_graph(nodes = nodes[nodes$team == 'bogong00219',], edges = edges[edges$problem == levels(edges$problem)[2],])
  layout2 = create_layout(graph2, layout = 'kk')
  
  p1 = ggraph(layout1) +
    geom_edge_fan(aes(colour = weight,
                      alpha = stat(index)),
                  strength = 5,
                  edge_width = 1,
                  show.legend = T) + 
    scale_edge_alpha(guide = F) +
    scale_edge_colour_viridis(limits = c(1,22),
                            option = "viridis",
                            begin = 0,
                            end = 0.95,
                            name = "Interaction\nCount",
                            direction = -1) +
    geom_node_point(size = 1) +
    scale_x_continuous(expand = expansion(mult = .1)) +
    scale_y_continuous(expand = expansion(mult = .1)) +
    facet_edges(vars(problem),
                nrow = 1,
                ncol = 2,
                scales = "free",
                drop = T) +
    theme_huntlab()
  
  p2 = ggraph(layout2) +
    geom_edge_fan(aes(colour = weight,
                      alpha = stat(index)),
                  strength = 5,
                  edge_width = 1,
                  show.legend = T) + 
    scale_edge_alpha(guide = F) +
    scale_edge_colour_viridis(limits = c(1,22),
                              option = "viridis",
                              begin = 0,
                              end = 0.95,
                              name = "Interaction\nCount",
                              direction = -1) +
    geom_node_point(size = 1) +
    scale_x_continuous(expand = expansion(mult = .1)) +
    scale_y_continuous(expand = expansion(mult = .1)) +
    facet_edges(vars(problem),
                nrow = 1,
                ncol = 2,
                scales = "free",
                drop = T) +
    theme_huntlab()
  
  # for (k in 1:nrow(layout1)) {
  #   animal = avatarLookup[[sub("\\d+", "", layout1$name[k])]]
  #   avtr = readPNG(paste0("/home/luke/Documents/Hunt Lab/wd_HuntLab/huntr/R/avatars/",animal,"@2x.png"))
  #   grb = rasterGrob(avtr, interpolate = T)
  #   x = layout1$x[k]
  #   y = layout1$y[k]
  #   p1 = p1 + annotation_custom(grb, xmin = x - 0.17, xmax = x + 0.17, ymin = y - 0.17, ymax = y + 0.17)
  # }
  # 
  # for (k in 1:nrow(layout2)) {
  #   animal = avatarLookup[[sub("\\d+", "", layout2$name[k])]]
  #   avtr = readPNG(paste0("/home/luke/Documents/Hunt Lab/wd_HuntLab/huntr/R/avatars/",animal,"@2x.png"))
  #   grb = rasterGrob(avtr, interpolate = T)
  #   x = layout2$x[k]
  #   y = layout2$y[k]
  #   p2 = p2 + annotation_custom(grb, xmin = x - 0.32, xmax = x + 0.32, ymin = y - 0.32, ymax = y + 0.32)
  # }
  
  p = p1 + p2 + plot_layout(guides = 'collect') +
    plot_annotation(
      title = 'COMPARISON NETWORKS',
      subtitle = 'Two comparison networks, provided for context.',
      theme = theme(plot.margin = margin(10, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "team_dynamics_reference.png",
                instance_name,
                team_name,
                "(A4-title)/3.8")
  }
  
}



plot_timeline = function(instance_name, team_name, export = F) {
    
  timeline = repo[[instance_name]]$PlatformData$timeline
  timeline = timeline[,.(timestamp, user, team, problem, type)]
  colnames(timeline)[1] = 'timestamp'
  chat = repo[[instance_name]]$PlatformData$chat
  chat = chat[,.(created_at, author_name, team_name, problem_title)]
  colnames(chat) = c('timestamp', 'user', 'team', 'problem')
  chat = chat[problem %in% c('Foreign Fighters',
                             'Forecasting Piracy',
                             'Corporate Espionage',
                             'The Park Young-min Case')]
  chat$type = "chat"
  chat$timestamp = paste0(chat$timestamp, ':00+00:00')
  timeline = rbind(timeline, chat)
  
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
  
  if (team_name == 'kosciuszko00219') {
    closeDates[['The Park Young-min Case']] = "2020-04-01 17:00"
  }

  D$time = NA
  D$time = suppressMessages(
    int_length(interval(
      ymd_hms(D$timestamp, tz = "Australia/Melbourne"),
      ymd_hm(unlist(closeDates[D$problem], use.names = F), tz = "Australia/Melbourne")
    ))/(60*60*24)
  )
  D$timestamp = as.POSIXct(D$timestamp, tz = "Australia/Melbourne")
  D$type = factor(D$type, levels = c(
    'resource',
    'report',
    'chat',
    'comment',
    'rating',
    'update'
  ))
  
  plots = list()

  for (k in 1:length(problems)) {
    
    plots[[k]] = ggplot(data=D[D$problem == problems[k],], aes(x=time, group=type, fill=type)) +
      geom_density(bw = .1,
                   linetype = 0,
                   position = "stack",
                   kernel = "gaussian") +
      scale_fill_manual(breaks = c("resource", "report", "chat", "comment", "rating", "update"),
                        values = c("#F39B7F", "#E64B35", "#91D1C2", "#00A087", "#3C5488FF", "#4DBBD5"),
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


plot_timeline_reference = function(instance_name, team_name, export = F) {
  
  timeline = repo[[instance_name]]$PlatformData$timeline
  timeline = timeline[,.(timestamp, user, team, problem, type)]
  colnames(timeline)[1] = 'timestamp'
  chat = repo[[instance_name]]$PlatformData$chat
  chat = chat[,.(created_at, author_name, team_name, problem_title)]
  colnames(chat) = c('timestamp', 'user', 'team', 'problem')
  chat = chat[problem %in% c('Foreign Fighters',
                             'Forecasting Piracy',
                             'Corporate Espionage',
                             'The Park Young-min Case')]
  chat$type = "chat"
  chat$timestamp = paste0(chat$timestamp, ':00+00:00')
  timeline = rbind(timeline, chat)
  
  teams = unique(timeline$team)
  problems = unique(timeline$problem)
  
  D = as.data.frame(timeline)
  
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
  
  if (team_name == 'kosciuszko00219') {
    closeDates[['The Park Young-min Case']] = "2020-04-01 17:00"
  }
  
  D$time = NA
  D$time = suppressMessages(
    int_length(interval(
      ymd_hms(D$timestamp, tz = "Australia/Melbourne"),
      ymd_hm(unlist(closeDates[D$problem], use.names = F), tz = "Australia/Melbourne")
    ))/(60*60*24)
  )
  D$timestamp = as.POSIXct(D$timestamp, tz = "Australia/Melbourne")
  D$type = factor(D$type, levels = c(
    'resource',
    'report',
    'chat',
    'comment',
    'rating',
    'update'
  ))
  
  plots = list()
  
    plots[[1]] = ggplot(data = D, aes(x = time, group = type, fill = type)) +
      geom_density(bw = .1,
                   linetype = 0,
                   position = "stack",
                   kernel = "gaussian") +
      scale_fill_manual(breaks = c("resource", "report", "chat", "comment", "rating", "update"),
                        values = c("#F39B7F", "#E64B35", "#91D1C2", "#00A087", "#3C5488FF", "#4DBBD5"),
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
      scale_fill_manual(breaks = c("resource", "report", "chat", "comment", "rating", "update"),
                        values = c("#F39B7F", "#E64B35", "#91D1C2", "#00A087", "#3C5488FF", "#4DBBD5"),
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
      scale_fill_manual(breaks = c("resource", "report", "chat", "comment", "rating", "update"),
                        values = c("#F39B7F", "#E64B35", "#91D1C2", "#00A087", "#3C5488FF", "#4DBBD5"),
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
                "timeline_reference.png",
                instance_name,
                team_name,
                "(A4-title)/3.8")
    
  }
  
}


plot_qor_teamsize = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0,]
  probteams[probteams$team == team_name,]$type = "Your Team"
  probteams$activeUsers = sqrt(probteams$activeUsersSq)
  
  p = ggplot(probteams, aes(x = activeUsers, y = avgIC)) +
    stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
                colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c(1, 1, 1, 1.5)) +
    labs(x = "Active Team Size",
         y = "Average IC Rating Scale",
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
      title = 'QOR v. ACTIVE TEAM SIZE',
      subtitle = 'Scatterplot of quality of reasoning scores (average IC Rating Scale) against number of active team\nmembers. There is one point for each instance of a team participating in a problem. A quadratic\nregression line and 95% confidence interval (in yellow) is overlaid on the plot.',
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

plot_qor_education = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0,]
  
  teams = as.data.frame(repo[[instance_name]]$CoreData$teams)
  probteams = merge(probteams, teams, by = c('team', 'type'), all.x = T)

  probteams[probteams$team == team_name,]$type = "Your Team"
  
  p = ggplot(probteams, aes(x = medianEdu, y = avgIC)) +
    stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
                colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c(1, 1, 1, 1.5)) +
    scale_x_continuous(breaks = 3:6,
                     labels = c('Bachelors\nDegree','Graduate Certificate,\nDiploma or equiv.','Masters','PhD')) +
    labs(x = "Median Education Level of Team Members",
         y = "Average IC Rating Scale",
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
      title = 'QOR v. EDUCATION LEVEL',
      subtitle = 'Scatterplot of quality of reasoning scores (average IC Rating Scale) against median education level of\nteam members. There is one point for each instance of a team participating in a problem. A quadratic\nregression line and 95% confidence interval (in yellow) is overlaid on the plot.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "qor_v_education.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}


plot_qor_AOMT = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams$team = as.character(probteams$team)
  teams = as.data.frame(repo[[instance_name]]$CoreData$teams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0,]
  probteams[probteams$team == team_name,]$type = "Your Team"
  probteams$AOMT = NA
  for (k in 1:nrow(probteams)) {
    probteams$AOMT[k] = teams[teams$team == probteams$team[k],]$AOMT[1]
  }
  
  
  p = ggplot(probteams, aes(x = AOMT, y = avgIC)) +
    stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
                colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c(1, 1, 1, 1.5)) +
    labs(x = "Actively Open-Minded Thinking",
         y = "Average IC Rating Scale",
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
      subtitle = 'Scatterplot of quality of reasoning scores (average IC Rating Scale) against the median AOMT score of\nteam members. There is one point for each instance of a team participating in a problem. A\nquadratic regression line and 95% confidence interval (in yellow) is overlaid on the plot.',
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
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams$team = as.character(probteams$team)
  teams = as.data.frame(repo[[instance_name]]$CoreData$teams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0,]
  probteams[probteams$team == team_name,]$type = "Your Team"
  probteams$divAOMT = NA
  for (k in 1:nrow(probteams)) {
    probteams$divAOMT[k] = teams[teams$team == probteams$team[k],]$divAOMT[1]
  }
  
  
  p = ggplot(probteams, aes(x = divAOMT, y = avgIC)) +
    stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
                colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c(1, 1, 1, 1.5)) +
    labs(x = "Diversity in Actively Open-Minded Thinking",
         y = "Average IC Rating Scale",
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
      subtitle = 'Scatterplot of quality of reasoning scores (average IC Rating Scale) against diversity of AOMT among\nteam members. There is one point for each instance of a team participating in a problem. A quadratic\nregression line and 95% confidence interval (in yellow) is overlaid on the plot.',
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
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0,]
  probteams[probteams$team == team_name,]$type = "Your Team"
  
  p = ggplot(probteams, aes(x = textSim, y = avgIC)) +
    stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
                colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c(1, 1, 1, 1.5)) +
    labs(x = "Text Similarity",
         y = "Average IC Rating Scale",
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
      subtitle = 'Scatterplot of quality of reasoning scores (average IC Rating Scale) against text similarity amongst a\nteams\' reports produced for a given problem. There is one point for each instance of a team participating\nin a problem. A quadratic regression line and 95% confidence interval (in yellow) is overlaid on the plot.',
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

plot_qor_activity = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0,]
  probteams = setDT(probteams)
  probteams = probteams[,.(team, type, problem, avgIC)]
  probparts = repo[[instance_name]]$CoreData$probparts
  probparts = probparts[,sum(engagement), by = c('team', 'problem')]
  probparts = probparts[!(problem %in% c('Test Problem',
                                         "'Sandpit' Problem",
                                         "Problem #1 Teaser - 'Foreign Fighters'"))]
  colnames(probparts)[3] = 'engagement'
  probteams = merge(probteams, probparts, by = c('team','problem'), all.x = T)
  
  probteams[probteams$team == team_name,]$type = "Your Team"
  probteams = as.data.frame(probteams)
  
  p = ggplot(probteams, aes(x = engagement, y = avgIC)) +
    stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
                colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c(1, 1, 1, 1.5)) +
    labs(x = "Total Engagement Count",
         y = "Average IC Rating Scale",
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
      title = 'QOR v. ENGAGEMENT',
      subtitle = 'Scatterplot of quality of reasoning scores (average IC Rating Scale) against total activity counts for each\nteam and problem. There is one point for each instance of a team participating in a problem. A\nquadratic regression line and 95% confidence interval (in yellow) is overlaid on the plot.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "qor_v_activity.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}

plot_qor_nGeoCorrect = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0 & !is.na(probteams$nGeoCorrect),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  
  p = ggplot(probteams, aes(x = avgIC, y = nGeoCorrect)) +
    # stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
    #             colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    # xlim(8, 32) + ylim(0, 4) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c(1, 1, 1, 1.5)) +
    labs(x = "Average IC Rating Scale",
         y = "# Geolocation Challenges Correct",
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
      title = 'GEOLOCATION SUCCESS v. QOR',
      subtitle = 'Scatterplot of the number of images successfully geolocated against quality of reasoning for each team\nthat participated in the \'Foreign Fighters\' problem.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "qor_v_nGeoCorrect.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}

plot_qor_forecasting = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0 & !is.na(probteams$probabilityEstimate),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  
  probteams$brier = probteams$probabilityEstimate^2
  
  p = ggplot(probteams, aes(x = avgIC, y = brier)) +
    # stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
    #             colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    # xlim(8, 32) + ylim(0, 4) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c(1, 1, 1, 1.5)) +
    labs(x = "Average IC Rating Scale",
         y = "Brier Score",
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
      title = 'BRIER SCORE v. QOR',
      subtitle = 'Scatterplot of the Brier scores against quality of reasoning for each team that participated in the\n\'Forecasting Piracy\' problem.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "qor_v_forecasting.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}

plot_qor_tightness = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0 & !is.na(probteams$tightness),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  
  p = ggplot(probteams, aes(x = avgIC, y = tightness)) +
    # stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
    #             colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    # xlim(8, 32) + ylim(0, 4) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c(1, 1, 1, 1.5)) +
    labs(x = "Average IC Rating Scale",
         y = "Tightness Score",
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
      title = 'TIGHTNESS v. QOR',
      subtitle = 'Scatterplot of the tightness scores against quality of reasoning for each team that participated in the\n\'Forecasting Piracy\' problem. Lower scores indicate tighter reasoning.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "qor_v_tightness.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}

plot_qor_nBayesCorrect = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0 & !is.na(probteams$nBayesCorrect),]
  if (team_name %in% probteams$team) {
    probteams[probteams$team == team_name,]$type = "Your Team"
  }
  
  p = ggplot(probteams, aes(x = avgIC, y = nBayesCorrect)) +
    # stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
    #             colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    # xlim(8, 32) + ylim(0, 4) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c(1, 1, 1, 1.5)) +
    labs(x = "Average IC Rating Scale",
         y = "# Bayesian Problems Correct",
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
      title = 'PROBABILISTIC REASONING v. QOR',
      subtitle = 'Scatterplot of the number of Bayesian problems successfully solved against quality of reasoning for each\nteam that participated in the \'Corporate Espionage\' problem.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "qor_v_nBayesCorrect.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}

plot_qor_nFlawsDetected = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & probteams$avgIC > 0 & !is.na(probteams$nFlawsDetected),]
  if (team_name %in% probteams$team) {
    probteams[probteams$team == team_name,]$type = "Your Team"
  }
  
  p = ggplot(probteams, aes(x = avgIC, y = nFlawsDetected)) +
    # stat_smooth(data = probteams, method = "lm", formula = y ~ x + I(x^2), size = 0.5,
    #             colour = "#000000", fill = "#fedb4a", alpha = 0.2) +
    geom_point(aes(size = type, colour = type)) +
    # xlim(8, 32) + ylim(0, 4) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_size_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c(1, 1, 1, 1.5)) +
    labs(x = "Average IC Rating Scale",
         y = "# Reasoning Flaws Detected",
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
      title = 'REASONING FLAW DETECTION v. QOR',
      subtitle = 'Scatterplot of the number of reasoning flaws detected against quality of reasoning for each\nteam that participated in the \'Park Young-min Case\' problem.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "qor_v_nFlawsDetected.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}

plot_dot_engagement = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  probteams$type = factor(probteams$type, levels = c('PT','ST','OT','Your Team'))
  
  analytics = repo[[instance_name]]$PlatformData$analytics
  analytics = analytics[team %in% probteams$team & problem %in% probteams$problem,
                        lapply(.SD, sum),
                        by = c('team', 'problem'),
                        .SDcols = c(
                          "engagement",
                          "chat_count",
                          "comment_count",
                          "resource_count",
                          "report_count",
                          "comment_vote_count",
                          "resource_vote_count",
                          "simple_rating",
                          "partial_rating",
                          "complete_rating"
                        )]
  D = merge(probteams, analytics, by = c('team', 'problem'), all.x = T)
  
  p = ggplot(D, aes(engagement)) +
    geom_dotplot(aes(fill = type), 
                 binwidth = .1,
                 method = "histodot",
                 stackgroups = T) +
    scale_y_continuous(NULL, breaks = NULL) +
    scale_x_continuous(breaks = c(0,10,100,1000,10000),
                       limits = c(1,10000),
                       trans = 'log10') +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35"),
                      drop = F) +
    labs(title = NULL,
         x = 'Overall Activity Score ',
         y = NULL,
         fill = "Type") +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          plot.title = element_text(color = "#014085", size = unit(11, "pt")),
          legend.position = "top"
    )
  
  p = p +
    plot_layout(guides = "keep") +
    plot_annotation(
      title = 'DISTRIBUTION OF PLATFORM ACTIVITY BY TEAM',
      subtitle = 'Dot plot of overall activity scores for each team and problem. Note that counts are on a log scale. Your\nteam is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_engagement.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}

plot_dot_engagement_user = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  probteams$type = factor(probteams$type, levels = c('PT','ST','OT','Your Team'))
  
  analytics = repo[[instance_name]]$PlatformData$analytics
  analytics = analytics[team %in% probteams$team & problem %in% probteams$problem,
                        lapply(.SD, sum),
                        by = c('user','team','problem'),
                        .SDcols = c(
                          "engagement",
                          "chat_count",
                          "comment_count",
                          "resource_count",
                          "report_count",
                          "comment_vote_count",
                          "resource_vote_count",
                          "simple_rating",
                          "partial_rating",
                          "complete_rating"
                        )]
  D = merge(probteams, analytics, by = c('team', 'problem'), all.y = T)
  D = D[!is.na(D$type),]
  
  p = ggplot(D, aes(engagement)) +
    geom_dotplot(aes(fill = type), 
                 binwidth = .04,
                 method = "histodot",
                 stackgroups = T) +
    scale_y_continuous(NULL, breaks = NULL) +
    scale_x_continuous(breaks = c(1,10,100,1000),
                       limits = c(1,1000),
                       trans = 'log10') +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35"),
                      drop = F) +
    labs(title = NULL,
         x = 'Overall Activity Score ',
         y = NULL,
         fill = "Type") +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          plot.title = element_text(color = "#014085", size = unit(11, "pt")),
          legend.position = "top"
    )
  
  p = p +
    plot_layout(guides = "keep") +
    plot_annotation(
      title = 'DISTRIBUTION OF PLATFORM ACTIVITY BY USER',
      subtitle = 'Dot plot of overall activity scores for each user and problem. Note that counts are on a log scale. Your\nteam members are indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_engagement_user.png",
                instance_name,
                team_name,
                "(A4-title)/2")
  }
  
}

plot_dot_qor = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  probteams$type = factor(probteams$type, levels = c('PT','ST','OT','Your Team'))
  
  ps = list()
  pcs = list()
  for (pb in 1:4) {
    ps[[pb]] = ggplot(probteams[probteams$probNum == pb,], aes(avgIC)) +
      geom_dotplot(aes(fill = type), 
                   binwidth = .5, 
                   # stroke = 0,
                   method = "histodot",
                   stackgroups = T) +
      scale_y_continuous(NULL, breaks = NULL) +
      scale_x_continuous(breaks = c(8,12,16,20,24,28,32),
                         limits = c(8,32)) +
      scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35"),
                        drop = F) +
      labs(title = probteams[probteams$probNum == pb,]$problem[1],
           x = NULL,
           y = NULL,
           fill = "Type") +
      # guides(colour = guide_legend(override.aes = list(stroke = 0))) +
      theme_huntlab() +
      theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
            panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
            plot.title = element_text(color = "#014085", size = unit(11, "pt")),
            legend.position = "right"
      )
    
    teamVal = probteams[probteams$probNum == pb & probteams$type == "Your Team",]$avgIC[1]
    
    # PT, ST, OT
    # "#00a087", "#f9a825", "#3c5488"
    if (pb %in% 1:2) {
      pubtype = "PT"
      pubcaption = "of public teams"
      pubcolour = "#00a087"
    } else {
      pubtype = "ST"
      pubcaption = "of superteams"
      pubcolour = "#f9a825"
    }
    
    pcs[[pb]] = ggplot() +
      scale_x_continuous(expand = c(0,0), limits = c(1,5)) + 
      scale_y_continuous(expand = c(0,0), limits = c(0,100))
    
    if (!is.na(teamVal)) {
      pcs[[pb]] = pcs[[pb]] + 
        annotate("text",
                 x = 1, y = 80,
                 hjust = 0, vjust = 1,
                 label = paste0("Your teams' QoR score of ", teamVal, " was as good or better than that of:")) +
        annotate("text",
                 x = 1.8, y = 40, size = 6, fontface = 2, vjust = 0,
                 label = paste0(round(100*mean(probteams[probteams$probNum == pb,]$avgIC <= teamVal)),'%'),
                 colour = "#000000") +
        annotate("text",
                 x = 1.8, y = 33, vjust = 1,
                 label = "of all teams",
                 colour = "#000000") +
        annotate("text",
                 x = 2.8, y = 40, size = 6, fontface = 2, vjust = 0,
                 label = paste0(round(100*mean(probteams[probteams$probNum == pb & probteams$type == pubtype,]$avgIC <= teamVal)),'%'),
                 colour = pubcolour) +
        annotate("text",
                 x = 2.8, y = 33, vjust = 1,
                 label = pubcaption,
                 colour = pubcolour) +
        annotate("text",
                 x = 4, y = 40, size = 6, fontface = 2, vjust = 0,
                 label = paste0(round(100*mean(probteams[probteams$probNum == pb & probteams$type == "OT",]$avgIC <= teamVal)),'%'),
                 colour = "#3c5488") +
        annotate("text",
                 x = 4, y = 33, vjust = 1,
                 label = "of organisational teams",
                 colour = "#3c5488")
    }
    
    pcs[[pb]] = pcs[[pb]] +
      theme_void() +
      theme(panel.background = element_rect(fill = "#f6f6f6",
                                            linetype = 0),
            legend.position = "right")
      
  }
  
  p = (ps[[1]]/pcs[[1]]/ps[[2]]/pcs[[2]]/ps[[3]]/pcs[[3]]/ps[[4]]/pcs[[4]]) +
    plot_layout(guides = "collect",
                heights = c(2,3,2,3,2,3,2,3)) +
    plot_annotation(
      title = 'DISTRIBUTION OF AVERAGE QUALITY OF REASONING',
      subtitle = 'Dot plot of average IC Rating Scale scores on each problem. Your team is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_qor.png",
                instance_name,
                team_name,
                "A4")
  }
  
}

plot_dot_qor_subscales_old = function(instance_name, team_name, export = F) {
  
  rates = repo[[instance_name]]$CoreData$rates
  rates = rates[!is.na(c1) & team != 'Calibration_team', .(problem, team,
                              c1, c2, c3, c4, c5, c6, c7, c8)]
  rates = rates[team != 'tongariro00311*']
  rates[rates == 'Poor'] = 1
  rates[rates == 'Fair'] = 2
  rates[rates == 'Good'] = 3
  rates[rates == 'Excellent'] = 4
  
  for (cl in paste0('c',1:8)) {
    rates[[cl]] = as.numeric(rates[[cl]])
  }
  
  rates = rates[, lapply(.SD, mean), by = 'team', .SDcols = paste0('c',1:8)]
  
  teams = repo[[instance_name]]$CoreData$teams[,.(team, type)]
  teams = merge(teams, rates, by = c('team'), all = T)
  teams = as.data.frame(teams)
  
  teams[teams$team == team_name,]$type = "Your Team"
  teams$type = factor(teams$type, levels = c('PT','ST','OT','Your Team'))
  
  criteriaDescriptions = c(
    'Criterion 1 - Describes sources, data, methodologies',
    'Criterion 2 - Expresses and explains uncertainties',
    'Criterion 3 - Properly distinguishes underlying intelligence information and assumptions\nand judgments',
    'Criterion 4 - Incorporates analysis of alternatives',
    'Criterion 5 - Demonstrates relevance and addresses implications',
    'Criterion 6 - Uses clear and logical argumentation',
    'Criterion 7 - Makes accurate judgements and assessments',
    'Criterion 8 - Incorporates effective visual information where appropriate'
  )
  
  ps = list()
  pcs = list()
  for (k in 1:8) {
    criteria = sym(paste0('c',k))
    ps[[k]] = ggplot(teams, aes(!!criteria)) +
      geom_dotplot(aes(fill = type), 
                   binwidth = .05, 
                   # stroke = 0,
                   method = "histodot",
                   stackgroups = T) +
      scale_y_continuous(NULL, breaks = NULL) +
      scale_x_continuous(breaks = 1:4,
                         limits = c(1,4),
                         labels = c('Poor', 'Fair', 'Good', 'Excellent')) +
      scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35"),
                        drop = F) +
      labs(title = criteriaDescriptions[k],
           x = NULL,
           y = NULL,
           fill = "Type") +
      # guides(colour = guide_legend(override.aes = list(stroke = 0))) +
      theme_huntlab() +
      theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
            panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
            plot.title = element_text(color = "#014085", size = unit(11, "pt")),
            legend.position = "right"
      )
    
    teamVal = teams[teams$type == "Your Team",][[paste0('c', k)]][1]
    
    # PT, ST, OT
    # "#00a087", "#f9a825", "#3c5488"
    
    pcs[[k]] = ggplot() +
      scale_x_continuous(expand = c(0,0), limits = c(1,5)) + 
      scale_y_continuous(expand = c(0,0), limits = c(0,100)) + 
      annotate("text",
               x = 1, y = 80,
               hjust = 0, vjust = 1,
               label = paste0("Your teams' average rating on Criteria ", k, " was as high or higher than that of:")) +
      annotate("text",
               x = 1.6, y = 40, size = 6, fontface = 2, vjust = 0,
               label = paste0(round(100*mean(teams[[paste0('c',k)]] <= teamVal)),'%'),
               colour = "#000000") +
      annotate("text",
               x = 1.6, y = 33, vjust = 1,
               label = "of all teams",
               colour = "#000000") +
      annotate("text",
               x = 2.4, y = 40, size = 6, fontface = 2, vjust = 0,
               label = paste0(round(100*mean(teams[teams$type == 'PT',][[paste0('c',k)]] <= teamVal)),'%'),
               colour = "#00a087") +
      annotate("text",
               x = 2.4, y = 33, vjust = 1,
               label = "of public teams",
               colour = "#00a087") +
      annotate("text",
               x = 3.3, y = 40, size = 6, fontface = 2, vjust = 0,
               label = paste0(round(100*mean(teams[teams$type == 'ST',][[paste0('c',k)]] <= teamVal)),'%'),
               colour = "#f9a825") +
      annotate("text",
               x = 3.3, y = 33, vjust = 1,
               label = "of superteams",
               colour = "#f9a825") +
      annotate("text",
               x = 4.3, y = 40, size = 6, fontface = 2, vjust = 0,
               label = paste0(round(100*mean(teams[teams$type == 'OT',][[paste0('c',k)]] <= teamVal)),'%'),
               colour = "#3c5488") +
      annotate("text",
               x = 4.3, y = 33, vjust = 1,
               label = "of organisational teams",
               colour = "#3c5488") +
      theme_void() +
      theme(panel.background = element_rect(fill = "#f6f6f6",
                                            linetype = 0),
            legend.position = "right")
  }
  
  p1234 = (ps[[1]]/pcs[[1]]/ps[[2]]/pcs[[2]]/ps[[3]]/pcs[[3]]/ps[[4]]/pcs[[4]]) +
    plot_layout(guides = "collect",
                heights = c(2,3,2,3,2,3,2,3)) +
    plot_annotation(
      title = 'AVERAGE SCORES ON QOR SUBSCALES (1-4) ',
      subtitle = 'Dot plot of the average rating (across all problems) for each team on each of the IC Rating Scale\ncriteria. Your team is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  p5678 = (ps[[5]]/pcs[[5]]/ps[[6]]/pcs[[6]]/ps[[7]]/pcs[[7]]/ps[[8]]/pcs[[8]]) +
    plot_layout(guides = "collect",
                heights = c(2,3,2,3,2,3,2,3)) +
    plot_annotation(
      title = 'AVERAGE SCORES ON QOR SUBSCALES (5-8) ',
      subtitle = 'Dot plot of the average rating (across all problems) for each team on each of the IC Rating Scale\ncriteria. Your team is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p1234,
                "dot_qor_subscales_1234.png",
                instance_name,
                team_name,
                "A4")
    export_plot(p5678,
                "dot_qor_subscales_5678.png",
                instance_name,
                team_name,
                "A4")
  }
  
}

plot_qor_subscales = function(instance_name, team_name, export = F) {
  
  rates = repo[[instance_name]]$CoreData$rates
  rates = rates[!is.na(c1) & team != 'Calibration_team', .(problem, team,
                                                           c1, c2, c3, c4, c5, c6, c7, c8)]
  rates = rates[team != 'tongariro00311*']
  rates[rates == 'Poor'] = 1
  rates[rates == 'Fair'] = 2
  rates[rates == 'Good'] = 3
  rates[rates == 'Excellent'] = 4
  
  for (cl in paste0('c',1:8)) {
    rates[[cl]] = as.numeric(rates[[cl]])
  }
  
  rates = rates[, lapply(.SD, mean), by = c('team', 'problem'), .SDcols = paste0('c',1:8)]
  
  teams = repo[[instance_name]]$CoreData$teams[,.(team, type)]
  teams = merge(teams, rates, by = c('team'), all = T)
  teams = melt(teams, id.vars = c('team', 'type', 'problem'))
  teams = as.data.frame(teams)
  teams[teams$team == team_name,]$type = "Your Team"
  teams$type = factor(teams$type, levels = c('PT','ST','OT','Your Team'))
  teams$variable = factor(teams$variable, levels = paste0('c', 8:1))
  
  # teams = teams[teams$problem == 'Forcasting Piracy',]
  
  criteriaDescriptions = c(
    '(1) Describes sources,\ndata, methodologies',
    '(2) Expresses and\nexplains uncertainties',
    '(3) Properly distinguishes\nunderlying intelligence\ninformation and assumptions\nand judgments',
    '(4) Incorporates analysis\nof alternatives',
    '(5) Demonstrates relevance and\naddresses implications',
    '(6) Uses clear and\nlogical argumentation',
    '(7) Makes accurate\njudgements and assessments',
    '(8) Incorporates effective visual\ninformation where appropriate'
  )
  
  means = copy(setDT(teams))
  means2 = copy(means)
  means2 = means2[type == 'Your Team']
  means2[,type := 'OT']
  means = rbind(means, means2)
  means = means[, mean(value), by = c('type', 'variable')]
  colnames(means)[3] = 'value'
  means = as.data.frame(means)
  set.seed(5678)
  means$value = means$value + runif(nrow(means), -0.05, .05)
  
  p = ggplot(teams, aes(x = value, y = variable, colour = type, fill = type)) +
    geom_jitter(data = teams[teams$type != 'Your Team'], height = 0.1, width = 0.2, alpha = 0.2) +
    geom_jitter(data = teams[teams$type == 'Your Team'], height = 0.1, width = 0.2, alpha = 1) +
    geom_tile(data = means,
              size = 1.5,
              width = 0,
              height = .5) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35"),
                      drop = T) +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                        values = c("#00a087", "#f9a825", "#3c5488", "#e64b35"),
                        drop = T) +
    # scale_colour_manual(breaks = c("OT","PT","ST"),
    #                     values = c("#3c5488", "#e64b35", "#4caf50"),
    #                     labels = c("Org Team", "Public Team", "Super Team"),
    #                     drop = T) +
    # scale_fill_manual(breaks = c("OT","PT","ST"),
    #                   values = c("#3c5488", "#e64b35", "#4caf50"),
    #                   labels = c("Org Team", "Public Team", "Super Team"),
    #                   drop = T) +
    scale_y_discrete(breaks = paste0('c', 1:8),
                     labels = criteriaDescriptions) +
    scale_x_continuous(breaks = 1:4,
                       limits = c(1,4),
                       labels = c('Poor', 'Fair', 'Good', 'Excellent')) +
    theme_huntlab() +
    labs(
      x = 'Average Score',
      y = NULL,
      colour = 'Type',
      size = 'Type',
      fill = 'Type'
    ) +
    theme(
      panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
      legend.position = "top"
    )
  
  p = p + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'AVERAGE SCORES ON QOR SUBSCALES',
      subtitle = 'Stripchart of the average rating for each team and problem on each of the IC Rating Scale criteria. The\noverall average for each team type is indicated by the vertical bars. Your team is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "qor_subscales.png",
                instance_name,
                team_name,
                "(A4-title)/2")
  }
  
}

plot_dot_geolocation = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & !is.na(probteams$nGeoCorrect),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  
  p = ggplot(probteams, aes(nGeoCorrect)) +
    geom_dotplot(aes(fill = type), 
                 binwidth = .07,
                 # stroke = 0,
                 method = "histodot",
                 stackgroups = T) +
    scale_y_continuous(NULL, breaks = NULL) +
    scale_x_continuous(breaks = 0:4,
                       limits = c(0,4)) +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    labs(x = NULL,
         y = NULL,
         fill = "Type") +
    # guides(colour = guide_legend(override.aes = list(stroke = 0))) +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          legend.position = "top"
    )
  
  # PT, ST, OT
  # "#00a087", "#f9a825", "#3c5488"
  
  teamVal = probteams[probteams$type == "Your Team",]$nGeoCorrect[1]
  
  pc = ggplot() +
    scale_x_continuous(expand = c(0,0), limits = c(1,5)) + 
    scale_y_continuous(expand = c(0,0), limits = c(0,100)) + 
    annotate("text",
             x = 1, y = 80,
             hjust = 0, vjust = 1,
             label = paste0("Your teams' solved as many or more geolocation problems than:")) +
    annotate("text",
             x = 1.8, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(probteams$nGeoCorrect <= teamVal)),'%'),
             colour = "#000000") +
    annotate("text",
             x = 1.8, y = 18, vjust = 1,
             label = "of all teams",
             colour = "#000000") +
    annotate("text",
             x = 2.8, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(probteams[probteams$type == "PT",]$nGeoCorrect <= teamVal)),'%'),
             colour = "#00a087") +
    annotate("text",
             x = 2.8, y = 18, vjust = 1,
             label = "of public teams",
             colour = "#00a087") +
    annotate("text",
             x = 4, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(probteams[probteams$type == "OT",]$nGeoCorrect <= teamVal)),'%'),
             colour = "#3c5488") +
    annotate("text",
             x = 4, y = 18, vjust = 1,
             label = "of organisational teams",
             colour = "#3c5488") +
    theme_void() +
    theme(panel.background = element_rect(fill = "#f6f6f6",
                                          linetype = 0))
  
  p = (p/pc) + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'NUMBER OF CORRECT GEOLOCATIONS',
      subtitle = 'Dot plot of the number of correct geolocations by each team. Your team is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_geolocation.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}

plot_dot_probability = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & !is.na(probteams$probabilityEstimate),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  
  p = ggplot(probteams, aes(probabilityEstimate)) +
    geom_dotplot(aes(fill = type), 
                 binwidth = 0.02, 
                 # stroke = 0,
                 method = "histodot",
                 stackgroups = T) +
    scale_y_continuous(NULL, breaks = NULL, limits = c(0, 0.25)) +
    scale_x_continuous(breaks = c(0,.2,.4,.6,.8,1),
                       limits = c(0,1)) +
    # scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
    #                     values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_fill_manual(breaks = c("OT","PT","ST"),
                      values = c("#3c5488", "#e64b35", "#4caf50"),
                      labels = c("Org Team", "Public Team", "Super Team"),
                      drop = T) +
    labs(x = NULL,
         y = NULL,
         fill = "Type") +
    # guides(colour = guide_legend(override.aes = list(stroke = 0))) +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          legend.position = "top"
    )
  
  # PT, ST, OT
  # "#00a087", "#f9a825", "#3c5488"
  
  # teamVal = probteams[probteams$type == "Your Team",]$probabilityEstimate[1]
  # 
  # pc = ggplot() +
  #   scale_x_continuous(expand = c(0,0), limits = c(1,5)) + 
  #   scale_y_continuous(expand = c(0,0), limits = c(0,100)) + 
  #   annotate("text",
  #            x = 1, y = 80,
  #            hjust = 0, vjust = 1,
  #            label = paste0("Your teams' forecast of ", teamVal, " was as good or better than that of:")) +
  #   annotate("text",
  #            x = 1.8, y = 25, size = 10, fontface = 2, vjust = 0,
  #            label = paste0(round(100*mean(probteams$probabilityEstimate >= teamVal)),'%'),
  #            colour = "#000000") +
  #   annotate("text",
  #            x = 1.8, y = 18, vjust = 1,
  #            label = "of all teams",
  #            colour = "#000000") +
  #   annotate("text",
  #            x = 2.8, y = 25, size = 10, fontface = 2, vjust = 0,
  #            label = paste0(round(100*mean(probteams[probteams$type == "PT",]$probabilityEstimate >= teamVal)),'%'),
  #            colour = "#00a087") +
  #   annotate("text",
  #            x = 2.8, y = 18, vjust = 1,
  #            label = "of public teams",
  #            colour = "#00a087") +
  #   annotate("text",
  #            x = 4, y = 25, size = 10, fontface = 2, vjust = 0,
  #            label = paste0(round(100*mean(probteams[probteams$type == "OT",]$probabilityEstimate >= teamVal)),'%'),
  #            colour = "#3c5488") +
  #   annotate("text",
  #            x = 4, y = 18, vjust = 1,
  #            label = "of organisational teams",
  #            colour = "#3c5488") +
  #   theme_void() +
  #   theme(panel.background = element_rect(fill = "#f6f6f6",
  #                                        linetype = 0))
  
  p = p + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'DISTRIBUTION OF REPORT PROBABILITIES',
      subtitle = 'Dot plot of estimated probabilities in team reports. You teams\' estimate is in red',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_probability.png",
                instance_name,
                team_name,
                "(A4-title)/4")
  }
  
}

plot_dot_brier = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & !is.na(probteams$probabilityEstimate),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  
  probteams$brier = probteams$probabilityEstimate^2
  
  p = ggplot(probteams, aes(brier)) +
    geom_dotplot(aes(fill = type), 
                 binwidth = 0.02, 
                 # stroke = 0,
                 method = "histodot",
                 stackgroups = T) +
    scale_y_continuous(NULL, breaks = NULL, limits = c(0, 0.25)) +
    scale_x_continuous(breaks = c(0,.2,.4,.6,.8,1),
                       limits = c(0,1)) +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    labs(x = NULL,
         y = NULL,
         fill = "Type") +
    # guides(colour = guide_legend(override.aes = list(stroke = 0))) +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          legend.position = "top"
    )
  
  # PT, ST, OT
  # "#00a087", "#f9a825", "#3c5488"
  
  teamVal = probteams[probteams$type == "Your Team",]$brier[1]
  
  pc = ggplot() +
    scale_x_continuous(expand = c(0,0), limits = c(1,5)) + 
    scale_y_continuous(expand = c(0,0), limits = c(0,100)) + 
    annotate("text",
             x = 1, y = 80,
             hjust = 0, vjust = 1,
             label = paste0("Your teams' Brier score of ", teamVal, " was as good or better than that of:")) +
    annotate("text",
             x = 1.8, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(probteams$brier >= teamVal)),'%'),
             colour = "#000000") +
    annotate("text",
             x = 1.8, y = 18, vjust = 1,
             label = "of all teams",
             colour = "#000000") +
    annotate("text",
             x = 2.8, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(probteams[probteams$type == "PT",]$brier >= teamVal)),'%'),
             colour = "#00a087") +
    annotate("text",
             x = 2.8, y = 18, vjust = 1,
             label = "of public teams",
             colour = "#00a087") +
    annotate("text",
             x = 4, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(probteams[probteams$type == "OT",]$brier >= teamVal)),'%'),
             colour = "#3c5488") +
    annotate("text",
             x = 4, y = 18, vjust = 1,
             label = "of organisational teams",
             colour = "#3c5488") +
    theme_void() +
    theme(panel.background = element_rect(fill = "#f6f6f6",
                                          linetype = 0))
  
  p = (p/pc) + plot_layout(guides = "keep",
                           heights = c(3,4)) +
    plot_annotation(
      title = 'DISTRIBUTION OF BRIER SCORES',
      subtitle = 'Dot plot of the Brier scores for each team\'s forecast . Your teams\' score is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_brier.png",
                instance_name,
                team_name,
                "(A4-title)/3.5")
  }
  
}

plot_dot_tightness = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & !is.na(probteams$tightness),]
  probteams[probteams$team == team_name,]$type = "Your Team"
  
  p = ggplot(probteams, aes(tightness)) +
    geom_dotplot(aes(fill = type), 
                 binwidth = 0.0002, 
                 # stroke = 0,
                 method = "histodot",
                 stackgroups = T) +
    scale_y_continuous(NULL, breaks = NULL, limits = c(0, 0.25)) +
    # scale_x_continuous(breaks = c(0,.2,.4,.6,.8,1),
    #                    limits = c(0,1)) +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    labs(x = NULL,
         y = NULL,
         fill = "Type") +
    # guides(colour = guide_legend(override.aes = list(stroke = 0))) +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          legend.position = "top"
    )
  
  # PT, ST, OT
  # "#00a087", "#f9a825", "#3c5488"
  
  teamVal = probteams[probteams$type == "Your Team",]$tightness[1]
  
  pc = ggplot() +
    scale_x_continuous(expand = c(0,0), limits = c(1,5)) + 
    scale_y_continuous(expand = c(0,0), limits = c(0,100)) + 
    annotate("text",
             x = 1, y = 80,
             hjust = 0, vjust = 1,
             label = paste0("Your teams' reasoning was as tight or tighter than that of:")) +
    annotate("text",
             x = 1.8, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(probteams$tightness >= teamVal)),'%'),
             colour = "#000000") +
    annotate("text",
             x = 1.8, y = 18, vjust = 1,
             label = "of all teams",
             colour = "#000000") +
    annotate("text",
             x = 2.8, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(probteams[probteams$type == "PT",]$tightness >= teamVal)),'%'),
             colour = "#00a087") +
    annotate("text",
             x = 2.8, y = 18, vjust = 1,
             label = "of public teams",
             colour = "#00a087") +
    annotate("text",
             x = 4, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(probteams[probteams$type == "OT",]$tightness >= teamVal)),'%'),
             colour = "#3c5488") +
    annotate("text",
             x = 4, y = 18, vjust = 1,
             label = "of organisational teams",
             colour = "#3c5488") +
    theme_void() +
    theme(panel.background = element_rect(fill = "#f6f6f6",
                                          linetype = 0))
  
  p = (p/pc) + plot_layout(guides = "keep", height = c(2,3)) +
    plot_annotation(
      title = 'DISTRIBUTION OF TIGHTNESS SCORES',
      subtitle = 'Dot plot of tightness scores in team reports. The lower the score, the tighter the reasoning. Your teams\'\nscore is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_tightness.png",
                instance_name,
                team_name,
                "(A4-title)/3.5")
  }
  
}

plot_dot_aggregated_performance_old = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC),]
  
  tmqor = data.frame(
    team = unique(probteams$team),
    type = NA,
    avgICp1 = NA,
    avgICp2 = NA,
    avgICp3 = NA,
    avgICp4 = NA,
    brier = NA,
    tightness = NA,
    nGeoCorrect = NA,
    nBayesCorrect = NA,
    nFlawsDetected = NA
  )
  for (k in 1:nrow(tmqor)) {
    tm = tmqor$team[k]
    tmqor$type[k] = probteams[probteams$team == tm,]$type[1]
    tmqor$avgICp1[k] = probteams[probteams$team == tm & probteams$problem == 'Foreign Fighters',]$avgIC[1]
    tmqor$avgICp2[k] = probteams[probteams$team == tm & probteams$problem == 'Forecasting Piracy',]$avgIC[1]
    tmqor$avgICp3[k] = probteams[probteams$team == tm & probteams$problem == 'Corporate Espionage',]$avgIC[1]
    tmqor$avgICp4[k] = probteams[probteams$team == tm & probteams$problem == 'The Park Young-min Case',]$avgIC[1]
    tmqor$brier[k] = (probteams[probteams$team == tm & probteams$problem == 'Forecasting Piracy',]$probabilityEstimate[1])^2
    tmqor$tightness[k] = probteams[probteams$team == tm & probteams$problem == 'Forecasting Piracy',]$tightness[1]
    tmqor$nGeoCorrect[k] = probteams[probteams$team == tm & probteams$problem == 'Foreign Fighters',]$nGeoCorrect[1]
    tmqor$nBayesCorrect[k] = probteams[probteams$team == tm & probteams$problem == 'Corporate Espionage',]$nBayesCorrect[1]
    tmqor$nFlawsDetected[k] = probteams[probteams$team == tm & probteams$problem == 'The Park Young-min Case',]$nFlawsDetected[1]
  }
  
  tmqor[tmqor$team == team_name,]$type = "Your Team"
  
  # Ensure all measures are pointing in the right direction (higher = better).
  tmqor$brier = -1*tmqor$brier
  tmqor$tightness = -1*tmqor$tightness
  
  # Convert scores to ranks.
  for (k in 3:ncol(tmqor)) {
    tmqor[[k]] = rank(tmqor[[k]], na.last = 'keep', ties.method = 'average')/sum(!is.na(tmqor[[k]]))
  }
  
  # Compute aggregate QoR.
  tmqor$qor = NA
  for (k in 1:nrow(tmqor)) {
    tmqor$qor[k] = mean(as.numeric(tmqor[k,3:11]), na.rm = T)
  }
  
  # Impute missing values.
  
  # for (k in 1:ncol(tmqor)) {
  #   if (sum(is.na(tmqor[[k]])) > 0) {
  #     tmqor[is.na(tmqor[[k]]),][[k]] = mean(tmqor[[k]], na.rm = T)
  #   }
  # }
  
  # Perform Principal Components Analysis.
  
  # pca = prcomp(tmqor[,3:11],
  #               center = T,
  #               scale. = T)
  # tmqor$PC1 = pca$x[,1]
  
  p = ggplot(tmqor, aes(qor)) +
    geom_dotplot(aes(fill = type), 
                 binwidth = 0.025, 
                 # stroke = 0,
                 method = "histodot",
                 stackgroups = T) +
    scale_y_continuous(NULL, breaks = NULL, limits = c(0, 0.25)) +
    scale_x_continuous(breaks = c(0,.2,.4,.6,.8,1),
                       limits = c(0,1)) +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    labs(x = NULL,
         y = NULL,
         fill = "Type") +
    # guides(colour = guide_legend(override.aes = list(stroke = 0))) +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          legend.position = "top"
    )
  
  # PT, ST, OT
  # "#00a087", "#f9a825", "#3c5488"
  
  teamVal = tmqor[tmqor$type == "Your Team",]$qor[1]
  
  pc = ggplot() +
    scale_x_continuous(expand = c(0,0), limits = c(1,5)) + 
    scale_y_continuous(expand = c(0,0), limits = c(0,100)) + 
    annotate("text",
             x = 1, y = 80,
             hjust = 0, vjust = 1,
             label = paste0("Your teams' aggregated performance score was as higher or higher than that of:")) +
    annotate("text",
             x = 1.6, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(tmqor$qor <= teamVal)),'%'),
             colour = "#000000") +
    annotate("text",
             x = 1.6, y = 18, vjust = 1,
             label = "of all teams",
             colour = "#000000") +
    annotate("text",
             x = 2.4, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(tmqor[tmqor$type == "PT",]$qor <= teamVal)),'%'),
             colour = "#00a087") +
    annotate("text",
             x = 2.4, y = 18, vjust = 1,
             label = "of public teams",
             colour = "#00a087") +
    annotate("text",
             x = 3.3, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(tmqor[tmqor$type == "ST",]$qor <= teamVal)),'%'),
             colour = "#f9a825") +
    annotate("text",
             x = 3.3, y = 18, vjust = 1,
             label = "of superteams",
             colour = "#f9a825") +
    annotate("text",
             x = 4.3, y = 25, size = 10, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(tmqor[tmqor$type == "OT",]$qor <= teamVal)),'%'),
             colour = "#3c5488") +
    annotate("text",
             x = 4.3, y = 18, vjust = 1,
             label = "of organisational teams",
             colour = "#3c5488") +
    theme_void() +
    theme(panel.background = element_rect(fill = "#f6f6f6",
                                          linetype = 0))
  
  p = (p/pc) + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'AGGREGATED CHALLENGE PERFORMANCE',
      subtitle = 'Dot plot of aggregated performance scores for each team across the whole challenge. For each team,\nthe score is calculated by averaging the rescaled reversed rank of that team in each of the applicable\nperformance measures: IC rating scale for each of the problems, number of correct geolocation\nchallenges, forecast Brier score, tightness, number of correct Bayesian problems and number of\nreasoning flaws correctly detected. Your teams\' score is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_aggregated_performance.png",
                instance_name,
                team_name,
                "(A4-title)/2.5")
  }
  
}

plot_dot_aggregated_performance = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC),]
  
  tmqor = data.frame(
    team = unique(probteams$team),
    type = NA,
    avgICp1 = NA,
    avgICp2 = NA,
    avgICp3 = NA,
    avgICp4 = NA,
    brier = NA,
    tightness = NA,
    nGeoCorrect = NA,
    nBayesCorrect = NA,
    nFlawsDetected = NA
  )
  for (k in 1:nrow(tmqor)) {
    tm = tmqor$team[k]
    tmqor$type[k] = probteams[probteams$team == tm,]$type[1]
    tmqor$avgICp1[k] = probteams[probteams$team == tm & probteams$problem == 'Foreign Fighters',]$avgIC[1]
    tmqor$avgICp2[k] = probteams[probteams$team == tm & probteams$problem == 'Forecasting Piracy',]$avgIC[1]
    tmqor$avgICp3[k] = probteams[probteams$team == tm & probteams$problem == 'Corporate Espionage',]$avgIC[1]
    tmqor$avgICp4[k] = probteams[probteams$team == tm & probteams$problem == 'The Park Young-min Case',]$avgIC[1]
    tmqor$brier[k] = (probteams[probteams$team == tm & probteams$problem == 'Forecasting Piracy',]$probabilityEstimate[1])^2
    tmqor$tightness[k] = probteams[probteams$team == tm & probteams$problem == 'Forecasting Piracy',]$tightness[1]
    tmqor$nGeoCorrect[k] = probteams[probteams$team == tm & probteams$problem == 'Foreign Fighters',]$nGeoCorrect[1]
    tmqor$nBayesCorrect[k] = probteams[probteams$team == tm & probteams$problem == 'Corporate Espionage',]$nBayesCorrect[1]
    tmqor$nFlawsDetected[k] = probteams[probteams$team == tm & probteams$problem == 'The Park Young-min Case',]$nFlawsDetected[1]
  }
  
  tmqor[tmqor$team == team_name,]$type = "Your Team"
  
  # Ensure all measures are pointing in the right direction (higher = better).
  tmqor$brier = -1*tmqor$brier
  tmqor$tightness = -1*tmqor$tightness
  
  # # Convert scores to ranks.
  # for (k in 3:ncol(tmqor)) {
  #   tmqor[[k]] = rank(tmqor[[k]], na.last = 'keep', ties.method = 'average')/sum(!is.na(tmqor[[k]]))
  # }
  
  # # Compute aggregate QoR.
  # tmqor$qor = NA
  # for (k in 1:nrow(tmqor)) {
  #   tmqor$qor[k] = mean(as.numeric(tmqor[k,3:11]), na.rm = T)
  # }
  
  # Impute missing values.
  
  for (k in 1:ncol(tmqor)) {
    if (sum(is.na(tmqor[[k]])) > 0) {
      tmqor[is.na(tmqor[[k]]),][[k]] = mean(tmqor[[k]], na.rm = T)
    }
  }
  
  # Perform Principal Components Analysis.
  
  pca = prcomp(tmqor[,c(3:7,9:10)],
                center = T,
                scale. = T)
  tmqor$qor = pca$x[,1]
  
  p = ggplot(tmqor, aes(qor)) +
    geom_dotplot(aes(fill = type), 
                 binwidth = 0.17, 
                 # stroke = 0,
                 method = "histodot",
                 stackgroups = T) +
    scale_y_continuous(NULL, breaks = NULL, limits = c(0, 0.25)) +
    # scale_x_continuous(breaks = c(0,.2,.4,.6,.8,1),
    #                    limits = c(0,1)) +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    labs(x = 'Aggregated Performance Score (first principal component)',
         y = NULL,
         fill = "Type") +
    # guides(colour = guide_legend(override.aes = list(stroke = 0))) +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          legend.position = "top"
    )
  
  # PT, ST, OT
  # "#00a087", "#f9a825", "#3c5488"
  
  teamVal = tmqor[tmqor$type == "Your Team",]$qor[1]
  
  pc = ggplot() +
    scale_x_continuous(expand = c(0,0), limits = c(1,5)) + 
    scale_y_continuous(expand = c(0,0), limits = c(0,100)) + 
    annotate("text",
             x = 1, y = 80,
             hjust = 0, vjust = 1,
             label = paste0("Your teams' aggregated performance score was as high or higher than that of:")) +
    annotate("text",
             x = 1.6, y = 30, size = 6, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(tmqor$qor <= teamVal)),'%'),
             colour = "#000000") +
    annotate("text",
             x = 1.6, y = 23, vjust = 1,
             label = "of all teams",
             colour = "#000000") +
    annotate("text",
             x = 2.4, y = 30, size = 6, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(tmqor[tmqor$type == "PT",]$qor <= teamVal)),'%'),
             colour = "#00a087") +
    annotate("text",
             x = 2.4, y = 23, vjust = 1,
             label = "of public teams",
             colour = "#00a087") +
    annotate("text",
             x = 3.3, y = 30, size = 6, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(tmqor[tmqor$type == "ST",]$qor <= teamVal)),'%'),
             colour = "#f9a825") +
    annotate("text",
             x = 3.3, y = 23, vjust = 1,
             label = "of superteams",
             colour = "#f9a825") +
    annotate("text",
             x = 4.3, y = 30, size = 6, fontface = 2, vjust = 0,
             label = paste0(round(100*mean(tmqor[tmqor$type == "OT",]$qor <= teamVal)),'%'),
             colour = "#3c5488") +
    annotate("text",
             x = 4.3, y = 23, vjust = 1,
             label = "of organisational teams",
             colour = "#3c5488") +
    theme_void() +
    theme(panel.background = element_rect(fill = "#f6f6f6",
                                          linetype = 0))
  
  p = (p/pc) + plot_layout(guides = "keep",
                           heights = c(4,5)) +
    plot_annotation(
      title = 'AGGREGATED CHALLENGE PERFORMANCE',
      subtitle = 'Dot plot of aggregated performance scores for each team across the whole challenge. For each team,\nthe score is the projection of their multidimensional vector of performance measures onto the first\nprincipal component of all such vectors (see footnote for more explanation). Higher is better. Your teams\'\nscore is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_aggregated_performance.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}

plot_redaction_estimates = function(instance_name, team_name, export = F) {

  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  teams = as.data.frame(repo[[instance_name]]$CoreData$teams)
  ratings = repo[[instance_name]]$CoreData$rates
  
  R = ratings[isRedactionTestRating == "Yes",
                .(problem,
                  team,
                  rater,
                  raterProbabilityEstimate,
                  estTimeTaken,
                  estJustification,
                  estComments)]
  R = R[team != "Calibration_team"]
  tms = unique(R$team)
  R$isEst = TRUE
  R$tightness = NA
  
  computeTightness = function(tm) {
    i = which(probteams$team == tm & probteams$problem == "Forecasting Piracy")
    team_prob = probteams$probabilityEstimate[i]
    rater_probs = R[team == tm & isEst]$raterProbabilityEstimate
    tightness = mean((rater_probs - team_prob)^2)
    return(tightness)
  }
  
  for (tm in tms) {
    i = which(probteams$team == tm & probteams$problem == "Forecasting Piracy")
    newRow = data.table(
      problem = "Forecasting Piracy",
      team = tm,
      rater = NA,
      raterProbabilityEstimate = probteams$probabilityEstimate[i],
      estTimeTaken = NA,
      estJustification = NA,
      estComments = NA,
      isEst = FALSE,
      tightness = computeTightness(tm)
    )
    R = rbind(R, newRow)
  }
  
  teamsByTightness = R[isEst == FALSE][order(-tightness)]$team
  
  R = as.data.frame(R)
  R$team = factor(R$team, levels = teamsByTightness)
  
  R$type = NA
  for (k in 1:nrow(R)) {
    R$type[k] = probteams[as.character(probteams$team) == as.character(R$team[k]),]$type[1]
  }
  R[as.character(R$team) == team_name,]$type = "Your Team"
  
  p = ggplot(R, aes(x = raterProbabilityEstimate, y = team, colour = type)) +
    geom_point(aes(shape = isEst)) +
    scale_colour_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    scale_shape_manual(breaks = c(FALSE, TRUE),
                      values = c(19,1),
                      labels = c("Team", "Rater")) +
    # scale_colour_manual(breaks = c(FALSE, TRUE),
    #                     values = c("#ff0000", "#444444"),
    #                     labels = c("Team", "Rater")) +
    # scale_alpha_manual(breaks = c(FALSE, TRUE),
    #                    values = c(1, .5),
    #                    labels = c("Team", "Rater")) +
    scale_x_continuous(breaks = c(0,.2,.40,.60,.80,1),
                       limits = c(0,1),
                       expand = c(0,0)) +
    scale_y_discrete(breaks = teamsByTightness,
                     labels = teamsByTightness) +
    labs(x = "Probability",
         y = "Team",
         colour = "Type",
         shape = "Estimate\nmade by") +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.y = element_line(size = .5, colour = "#f6f6f6"))
  
  p = p + plot_layout(guides = "collect") +
    plot_annotation(
      title = 'REDACTION TEST ESTIMATES',
      subtitle = 'Stripchart showing the redaction test estimates for each team, along with their reported probability\nestimate. Teams are ordered by tightness score from most tight to least tight.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "redaction_estimates.png",
                instance_name,
                team_name,
                "(A4-title)/2")
  }

}

plot_dot_bayes = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & !is.na(probteams$nBayesCorrect),]
  if (team_name %in% probteams$team) {
    probteams[probteams$team == team_name,]$type = "Your Team"
  }
  
  p = ggplot(probteams, aes(nBayesCorrect)) +
    geom_dotplot(aes(fill = type), 
                 binwidth = .06,
                 # stroke = 0,
                 # method = "histodot",
                 stackgroups = T) +
    scale_y_continuous(NULL, breaks = NULL) +
    scale_x_continuous(breaks = 0:3,
                       limits = c(0,3.2)) +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    labs(x = NULL,
         y = NULL,
         fill = "Type") +
    # guides(colour = guide_legend(override.aes = list(stroke = 0))) +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          legend.position = "top"
    )
  
  # PT, ST, OT
  # "#00a087", "#f9a825", "#3c5488"
  
  pc = ggplot() +
    scale_x_continuous(expand = c(0,0), limits = c(1,5)) + 
    scale_y_continuous(expand = c(0,0), limits = c(0,100))
  
  if (team_name %in% probteams$team) {
    teamVal = probteams[probteams$type == "Your Team",]$nBayesCorrect[1]
    
    pc = pc + 
      annotate("text",
               x = 1, y = 80,
               hjust = 0, vjust = 1,
               label = paste0("Your team correctly solved as many or more Bayesian problems than:")) +
      annotate("text",
               x = 1.8, y = 25, size = 10, fontface = 2, vjust = 0,
               label = paste0(round(100*mean(probteams$nBayesCorrect <= teamVal)),'%'),
               colour = "#000000") +
      annotate("text",
               x = 1.8, y = 18, vjust = 1,
               label = "of all teams",
               colour = "#000000") +
      annotate("text",
               x = 2.8, y = 25, size = 10, fontface = 2, vjust = 0,
               label = paste0(round(100*mean(probteams[probteams$type == "ST",]$nBayesCorrect <= teamVal)),'%'),
               colour = "#f9a825") +
      annotate("text",
               x = 2.8, y = 18, vjust = 1,
               label = "of superteams",
               colour = "#f9a825") +
      annotate("text",
               x = 4, y = 25, size = 10, fontface = 2, vjust = 0,
               label = paste0(round(100*mean(probteams[probteams$type == "OT",]$nBayesCorrect <= teamVal)),'%'),
               colour = "#3c5488") +
      annotate("text",
               x = 4, y = 18, vjust = 1,
               label = "of organisational teams",
               colour = "#3c5488")
    
  }
  
  pc = pc + theme_void() +
    theme(panel.background = element_rect(fill = "#f6f6f6",
                                          linetype = 0))

  p = (p/pc) + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'NUMBER OF CORRECT BAYESIAN PROBLEMS',
      subtitle = 'Dot plot of the number of correct Bayesian problems by each team. Your team is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_bayes.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}

plot_dot_flawdetection = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC) & !is.na(probteams$nFlawsDetected),]
  if (team_name %in% probteams$team) {
    probteams[probteams$team == team_name,]$type = "Your Team"
  }
  
  p = ggplot(probteams, aes(nFlawsDetected)) +
    geom_dotplot(aes(fill = type), 
                 binwidth = .06,
                 # stroke = 0,
                 method = "histodot",
                 stackgroups = T) +
    scale_y_continuous(NULL, breaks = NULL) +
    scale_x_continuous(breaks = 0:4,
                       limits = c(-0.1,4.1)) +
    scale_fill_manual(breaks = c("PT","ST","OT","Your Team"),
                      values = c("#00a087", "#f9a825", "#3c5488", "#e64b35")) +
    labs(x = NULL,
         y = NULL,
         fill = "Type") +
    # guides(colour = guide_legend(override.aes = list(stroke = 0))) +
    theme_huntlab() +
    theme(panel.grid.major.x = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.x = element_line(size = .5, colour = "#f6f6f6"),
          legend.position = "top"
    )
  
  # PT, ST, OT
  # "#00a087", "#f9a825", "#3c5488"
  
  if (team_name %in% probteams$team) {
    teamVal = probteams[probteams$type == "Your Team",]$nFlawsDetected[1]
    
    pc = ggplot() +
      scale_x_continuous(expand = c(0,0), limits = c(1,5)) + 
      scale_y_continuous(expand = c(0,0), limits = c(0,100)) + 
      annotate("text",
               x = 1, y = 80,
               hjust = 0, vjust = 1,
               label = paste0("Your team detected as many or more reasoning flaws than:")) +
      annotate("text",
               x = 1.8, y = 25, size = 10, fontface = 2, vjust = 0,
               label = paste0(round(100*mean(probteams$nFlawsDetected <= teamVal)),'%'),
               colour = "#000000") +
      annotate("text",
               x = 1.8, y = 18, vjust = 1,
               label = "of all teams",
               colour = "#000000") +
      annotate("text",
               x = 2.8, y = 25, size = 10, fontface = 2, vjust = 0,
               label = paste0(round(100*mean(probteams[probteams$type == "ST",]$nFlawsDetected <= teamVal)),'%'),
               colour = "#f9a825") +
      annotate("text",
               x = 2.8, y = 18, vjust = 1,
               label = "of superteams",
               colour = "#f9a825") +
      annotate("text",
               x = 4, y = 25, size = 10, fontface = 2, vjust = 0,
               label = paste0(round(100*mean(probteams[probteams$type == "OT",]$nFlawsDetected <= teamVal)),'%'),
               colour = "#3c5488") +
      annotate("text",
               x = 4, y = 18, vjust = 1,
               label = "of organisational teams",
               colour = "#3c5488") +
      theme_void() +
      theme(panel.background = element_rect(fill = "#f6f6f6",
                                            linetype = 0))
    
    p = p/pc
  }
  
  p = p + plot_layout(guides = "keep", height = c(2,3)) +
    plot_annotation(
      title = 'NUMBER OF REASONING FLAWS DETECTED',
      subtitle = 'Dot plot of the number of reasoning flaws detected by each team. Your team is indicated in red.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "dot_flawsdetected.png",
                instance_name,
                team_name,
                "(A4-title)/3.5")
  }
  
}

plot_user_engagement = function(instance_name, team_name, export = F) {
  
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
  
  analytics = repo[[instance_name]]$PlatformData$analytics
  analytics = analytics[team == team_name & user != 'swarm-master',
                        .(user,
                          problem,
                            report_count,
                            resource_count,
                            comment_count,
                            chat_count,
                            comment_vote_count,
                            resource_vote_count,
                          simple_rating,
                          partial_rating,
                          complete_rating,
                          engagement_scaled
                          )]
  
  analytics = analytics[,`:=`(
    resource_raw = resource_count,
    report_raw = report_count,
    vote_raw = comment_vote_count + resource_vote_count,
    comment_raw = comment_count,
    complete_rating_raw = complete_rating,
    quick_rating_raw = simple_rating + partial_rating,
    chat_raw = chat_count
  )]
  normalise = function(x) {
    ( x - min(x, na.rm = T) ) / ( max(x, na.rm = T) - min(x, na.rm = T ) )
  }
  analytics$resource = normalise(analytics$resource_raw)
  analytics$report = normalise(analytics$report_raw)
  analytics$chat = normalise(analytics$chat_raw)
  analytics$comment = normalise(analytics$comment_raw)
  analytics$complete_rating = normalise(analytics$complete_rating_raw)
  analytics$quick_rating = normalise(analytics$quick_rating_raw)
  analytics$vote = normalise(analytics$vote_raw)
  
  Ab = analytics
  
  analytics = analytics[,.(
    user,
    problem,
    resource,
    report,
    chat,
    comment,
    complete_rating,
    quick_rating,
    vote,
    engagement_scaled
  )]
  
  prbs = c(
    'Foreign Fighters',
    'Forecasting Piracy',
    'Corporate Espionage',
    'The Park Young-min Case'
  )
  A = analytics[, engagement:=sum(engagement_scaled), by = c('user')]
  usrs = unique(A[order(-engagement)]$user)
  
  analytics = melt(analytics,
                   id.vars = c('user','problem'))
  analytics = analytics[variable != 'engagement_scaled']
  analytics = analytics[variable != 'engagement']
  
  analytics$raw = NA
  for (k in 1:nrow(analytics)) {
    analytics$raw[k] = Ab[user == analytics$user[k] & problem == analytics$problem[k]][[paste0(analytics$variable[k], '_raw')]][1]
  }
  
  analytics = as.data.frame(analytics)
  analytics$user = factor(analytics$user, levels = usrs, labels = paste('User', 1:length(usrs)))
  analytics$problem = factor(analytics$problem, levels = prbs)
  analytics = analytics[!is.na(analytics$problem),]
  
  analytics$nonZero = (analytics$raw > 0)
  
  probparts = repo[[instance_name]]$CoreData$probparts
  probparts = probparts[team == team_name & problem %in% prbs,
                        .(user,
                          problem,
                          clusterLabel)]
  probparts$value = 1.4
  probparts$variable = 'resource'
  probparts$problem = factor(probparts$problem, levels = prbs)
  probparts$user = factor(probparts$user, levels = usrs, labels = paste('User', 1:length(usrs)))
  
  analytics$variable = factor(analytics$variable,
                              levels = c('resource',
                                         'report',
                                         'chat',
                                         'comment',
                                         'quick_rating',
                                         'complete_rating',
                                         'vote'))
  
  probparts = probparts[!is.na(probparts$user),]
  
  p = ggplot(analytics, aes(x = variable, y = value, fill = variable)) +
    geom_col() +
    geom_text(aes(label = raw, colour = nonZero),
              size = 1.8,
              vjust = -.5) +
    geom_text(data = probparts,
              aes(label = clusterLabel,
                  x = -Inf,
                  y = -Inf),
              size = 2,
              hjust = 0,
              vjust = 0,
              inherit.aes = F) +
    facet_grid(rows = vars(user),
               cols = vars(problem),
               switch = 'y',
               drop = F) +
    guides(alpha = F,
           colour = F,
           fill = guide_legend(ncol = 6)) +
    labs(x = NULL,
         y = NULL,
         fill = NULL,
         title = 'ENGAGEMENT BY USER AND PROBLEM',
         subtitle = 'Column graph of the activity counts for different on-platform tasks by problem for each of the members\nof your team. Note that each activity type is on a different scale, to make it easier to see differences\nbetween users. Users are annotated with the \'User Role\' they played in each problem.') +
    scale_fill_manual(breaks = c('resource',
                                 'report',
                                 'chat',
                                 'comment',
                                 'quick_rating',
                                 'complete_rating',
                                 'vote'),
                      values = c("#F39B7FFF",
                                 "#E64B35FF",
                                 "#91D1C2FF",
                                 "#00A087FF",
                                 "#8491B4FF",
                                 "#3C5488FF",
                                 "#4DBBD5FF")) +
    scale_colour_manual(breaks = c(F, T),
                        values = c(NA, '#000000')) +
    scale_y_continuous(
      breaks = c(0,.25,.5,.75,1),
      limits = c(-.3, 1.3)) +
    theme_huntlab() +
    theme(panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.y = element_blank(),
          # axis.text.x = element_text(angle = -45, hjust = 0),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          strip.text.y.left = element_text(angle = 0,
                                           # vjust = -.05,
                                           colour = "#000000",
                                           size = 8),
          legend.position = 'bottom',
          plot.margin = margin(11, 10, 10, 10, "pt"),
          plot.background = element_rect(fill = "#f6f6f6"),
          plot.title = element_text(face = "bold",
                                    colour = "#014085"),
          plot.title.position = 'plot',
          plot.caption.position = 'plot'
    )
  
  # g = ggplot_gtable(ggplot_build(p))
  # 
  # avtrs = list()
  # for (k in 1:length(usrs)) {
  #   if (!(sub("\\d+", "", usrs[k]) %in% names(avatarLookup))) {
  #     message(sub("\\d+", "", usrs[k]))
  #   }
  #   animal = avatarLookup[[sub("\\d+", "", usrs[k])]]
  #   avtr = readPNG(paste0("/home/luke/Documents/Hunt Lab/wd_HuntLab/huntr/R/avatars/",animal,"@2x.png"))
  #   avtrs[[k]] = rasterGrob(avtr, width = unit(.6, 'cm'), height = unit(.6, 'cm'),
  #                           y = .65)
  # }
  # 
  # strips = grep("strip-l", g$layout$name)
  # g = with(g$layout[strips,],
  #           gtable_add_grob(g, avtrs,
  #                           t=t, l=l, b=b, r=r, name="strip_avatar") )
  
  if (export) {
    export_plot(p,
                "user_engagement.png",
                instance_name,
                team_name,
                "A4")
  }
  
}

plot_cluster_stripchart = function(instance_name, team_name, export = F) {
  
  set.seed(5678)
  
  anal = repo[[1]]$PlatformData$analytics
  anal$probteam = NA
  anal$teamFinished = NA
  anal = anal[0,]
  
  for (nm in names(repo)) {
    analytics = repo[[nm]]$PlatformData$analytics
    probteams = as.data.frame(repo[[nm]]$CoreData$probteams)
    
    analytics$probteam = paste0(analytics$team, analytics$problem)
    probteams$probteam = paste0(probteams$team, probteams$problem)
    
    teamFinished = function(pt) {
      return(pt %in% probteams$probteam)
    }
    analytics$teamFinished = sapply(analytics$probteam, teamFinished)
    analytics = analytics[analytics$teamFinished,]
    
    anal = rbind(anal, analytics)
  }
  
  # Select contributions for each user instance.
  anal = anal %>%
    select(team, problem, user, report_count, resource_count, comment_count, vote_count,
           quick_rating, complete_rating, chat_count)
  
  # Remove outliers: artificially capping chat counts to 100 so they don't cause outliers.
  anal[anal$chat_count >= 100,]$chat_count = 100
  
  # Scale data to a mean of 0 and a standard dev of 1 (relativates high number of chat messages etc.)
  scanal = apply(anal[, 4:10], 2, function(x) {(x-mean(x))/sd(x)})
  scanal = cbind(anal[,1:3], scanal)
  
  # Get Euclidean distances 
  d = dist(scanal[, 4:10]) 
  
  # Run hierarchical clustering with Ward method to determine the centers
  fit.ward = hclust(d, method = "ward.D")
  clusters = cutree(fit.ward, k = 10) # ward results are much more promising
  
  centers = aggregate(scanal[,4:10], list(clusters), median)
  
  # Test hierarchical with silhouette method.
  sil = cluster::silhouette(clusters, d)
  
  # Now use centers as starting points for k-means clustering.
  set.seed(42)
  fit.km = kmeans(scanal[,4:10], centers = centers[, 2:8], nstart = 1)
  
  # Silhouette width now increased to 0.3
  sil = silhouette(fit.km$cluster, d)
  
  # Stripcharts for k-means: 
  anal[['cluster']] = factor(fit.km$cluster)
  anal[['clusterLabel']] = character(nrow(anal))
  anal[anal$cluster == 1,]$clusterLabel = 'Talkative Multi-talent (Tier 2)'
  anal[anal$cluster == 2,]$clusterLabel = 'Talkative Multi-talent (Tier 1)' # 'Slow-rating Multi-talent (Tier 1)'
  anal[anal$cluster == 3,]$clusterLabel = 'Resource Guru' # 'Speed-rating Multi-talent (Tier 1)'
  anal[anal$cluster == 4,]$clusterLabel = 'Speed-rating Multi-talent (Tier 1)' # 'Allrounder (Tier 1)'
  anal[anal$cluster == 5,]$clusterLabel = 'Report Guru' # 'Slow-rating Multi-talent (Tier 2)'
  anal[anal$cluster == 6,]$clusterLabel = 'Allrounder' # 'Report Guru'
  anal[anal$cluster == 7,]$clusterLabel = 'Slow-rating Multi-talent (Tier 1)' # 'Allrounder (Tier 2)'
  anal[anal$cluster == 8,]$clusterLabel = 'Drop In' # 'Speed-rating Multi-talent (Tier 2)'
  anal[anal$cluster == 9,]$clusterLabel = 'Speed-rating Multi-talent (Tier 2)' # 'Single-minded Raters'
  anal[anal$cluster == 10,]$clusterLabel = 'Slow-rating Multi-talent (Tier 2)' # 'Drop In'
  
  D = anal
  for (cn in colnames(D)[4:10]) {
    D[[cn]] = D[[cn]]/max(D[[cn]])
  }
  D = melt(D, id.vars = c("team","problem","user","cluster","clusterLabel"))
  D$clusterLabel = factor(D$clusterLabel,
                          levels= c(
                                    'Allrounder',
                                    'Report Guru',
                                    'Resource Guru',
                                    'Talkative Multi-talent (Tier 1)',
                                    'Slow-rating Multi-talent (Tier 1)',
                                    'Speed-rating Multi-talent (Tier 1)',
                                    'Talkative Multi-talent (Tier 2)',
                                    'Slow-rating Multi-talent (Tier 2)',
                                    'Speed-rating Multi-talent (Tier 2)',
                                    'Drop In'))
  
  D[D$variable == 'report_count',]$variable = 'report'
  D[D$variable == 'resource_count',]$variable = 'resource'
  D[D$variable == 'chat_count',]$variable = 'chat'
  D[D$variable == 'comment_count',]$variable = 'comment'
  D[D$variable == 'vote_count',]$variable = 'vote'
  
  D = as.data.frame(D)
  D$variable = factor(D$variable,
                              levels = c(
                                         'vote',
                                         'complete_rating',
                                         'quick_rating',
                                         'comment',
                                         'chat',
                                         'report',
                                         'resource'
                                         ))
  
  
  pw = ggplot(D, aes(x = variable, y = value)) +
    geom_jitter(aes(colour = variable), alpha = 0.3) + ylim(0,1) +
    scale_colour_manual(breaks = c('resource',
                                 'report',
                                 'chat',
                                 'comment',
                                 'quick_rating',
                                 'complete_rating',
                                 'vote'),
                      values = c("#F39B7FFF",
                                 "#E64B35FF",
                                 "#91D1C2FF",
                                 "#00A087FF",
                                 "#8491B4FF",
                                 "#3C5488FF",
                                 "#4DBBD5FF")) +
    coord_flip() +
    guides(color = FALSE) +
    theme_linedraw() +
    labs(x = "",
         y = "Percentile",
         title = NULL) +
    facet_wrap(vars(clusterLabel), ncol = 3, nrow = 4) +
    theme_huntlab() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor.y = element_line(colour="grey", size=0.2),
        axis.text.x = element_text(angle = -45, hjust = 0))
  
  
  
  # P = list()
  # for (p in 1:10) {
  #   P[[p]] = ggplot(D[D$cluster == p,], aes(x = variable, y = value)) +
  #     geom_jitter(aes(colour = variable), alpha = 0.3) + ylim(0,1) +
  #     coord_flip() +
  #     guides(color = FALSE) +
  #     theme_linedraw() +
  #     labs(x = "",
  #          y = "Percentile",
  #          title = D[cluster == p]$clusterLabel[1]) +
  #     theme_huntlab()
  #     theme(panel.grid.major = element_blank(), panel.grid.minor.y = element_line(colour="grey", size=0.2))
  # }
  # pw = (P[[1]] + P[[2]] + P[[3]]) / (P[[4]] + P[[5]] + P[[6]]) / (P[[7]] + P[[8]] + P[[9]]) / (P[[10]] + plot_spacer() + plot_spacer())
  
  pw = pw + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'CHARACTERISATION OF USER ROLE CLUSTERS',
      subtitle = 'Stripcharts characterising each detected user role. Users within each user role cluster display similar\npatterns of activity and interaction on the SWARM platform. The data here includes data both from the\n2020 Hunt Challenge and the previous SWARM Challenge held in 2018.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(pw,
                "cluster_stripchart.png",
                instance_name,
                team_name,
                "A4")
  }
  
}

plot_bar_expectations = function(instance_name, team_name, export = F) {
  
  parts = as.data.frame(repo[[instance_name]]$CoreData$parts)
  # teamparts = as.data.frame(repo[[instance_name]]$CoreData$teamparts)
  # parts = merge(parts, teamparts, by = c('user'), all.y = T)
  parts = parts[!is.na(parts$exExpct1), c('user','isOrg',paste0('exExpct',1:10))]
  
  for (cl in paste0('exExpct',1:10)) {
    parts[[cl]] = factor(parts[[cl]],
                         levels = c(1,4,2,3),
                         labels = c('Below',
                                    'I had no expectations',
                                    'Met',
                                    'Exceeded'))
  }
  D = likert(parts[,3:12])
  p = plot(D,
       plot.percent.low = F,
       plot.percent.high = F,
       plot.percents = T,
       center = 2,
       include.center = T,
       group.order = paste0('exExpct',1:10),
       ordered = T,
       colors = c("#f57f17", "#b0bec5", "#cddc39", "#7cb342"),
       text.size = 2,
       legend.position = 'top') +
    scale_x_discrete(
      breaks = paste0('exExpct',1:10),
      labels = c(
        'Interesting\nproblems',
        'Reasonable\ntime commitment',
        'Difficult\nproblems',
        'Learning new\nskills and tools',
        'Problems are achievable,\nfor a team',
        'The platform will be a\nproductive work space',
        'Good training in using\nOSINT tools',
        'Positive team\nworking experience',
        'An effective collaboration,\ncompared to my normal methods',
        'What I learnt from the challenge\ncan be applied in my workplace'
      )
    ) +
    theme_huntlab() +
    theme(
      panel.background = element_rect(fill = '#f6f6f6'),
      axis.text.y = element_text(size = 9, colour = '#000000')
    )
  
  
  
  # parts = setDT(parts)
  # parts = melt(parts,
  #              id.vars = c('user','isOrg'))
  # parts = as.data.frame(parts)
  # parts$value = factor(parts$value,
  #                      levels = c(4,1,2,3),
  #                      labels = c('I had no expectations',
  #                                 'Below',
  #                                 'Met',
  #                                 'Exceeded'))
  # parts = parts[!is.na(parts$value),]
  # parts$variable = factor(parts$variable,
  #                         levels = paste0('exExpct', 1:10),
  #                         labels = c(
  #                           'Interesting\nproblems',
  #                           'Reasonable\ntime commitment',
  #                           'Difficult\nproblems',
  #                           'Learning new\nskills and tools',
  #                           'Problems are achievable,\nfor a team',
  #                           'The platform will be a\nproductive work space',
  #                           'Good training in using\nOSINT tools',
  #                           'Positive team\nworking experience',
  #                           'An effective collaboration,\ncompared to my normal methods',
  #                           'What I learnt from the challenge\ncan be applied in my workplace'
  #                         ))
  # 
  # parts$isOrg = as.character(parts$isOrg)
  # 
  # ggplot(parts, aes(y = isOrg, fill = value, alpha = isOrg)) +
  #   geom_bar(aes(x = 10), position = 'fill', width = .5) +
  #   scale_y_discrete(breaks = c('TRUE', 'FALSE'),
  #                    labels = c('O', 'P'),
  #                    position = 'right') +
  #   scale_x_continuous(expand = c(0.01,0),
  #                      breaks = c(0,.2,.4,.6,.8,1),
  #                      labels = c(0,20,40,60,80,100)) +
  #   scale_fill_manual(breaks = c("Exceeded","Met","Below","I had no expectations"),
  #                     values = c("#7cb342", "#cddc39", "#f57f17", "#b0bec5")) +
  #   scale_alpha_manual(breaks = c('TRUE', 'FALSE'),
  #                      values = c(1, 0.5),
  #                      guide = F) +
  #   facet_wrap(vars(variable),
  #              ncol = 1,
  #              strip.position = 'left') +
  #   labs(
  #     x = 'Percentage of Respondents (%)',
  #     y = NULL,
  #     fill = 'Response'
  #   ) +
  #   theme_huntlab() +
  #   theme(axis.ticks.y = element_blank(),
  #         panel.background = element_rect(fill = '#f6f6f6'),
  #         panel.grid.major.y = element_blank(),
  #         panel.grid.major.x = element_line(colour="#00000044", size=.1),
  #         panel.grid.minor.y = element_blank(),
  #         panel.grid.minor.x = element_line(colour="#00000044", size=.1),
  #         axis.text.y = element_text(size = 6, colour = '#000000'),
  #         panel.spacing = unit(0, "lines"),
  #         strip.text.y.left = element_text(angle = 0, vjust = -.05, colour = "#000000", hjust = 1),
  #         legend.position = "bottom"
  #   )
  
  p = p + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'WERE EXPECTATIONS MET?',
      subtitle = 'Stacked bar chart indicating the extent to which participants reported their expectations were met in\nseveral areas.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "bar_expectations.png",
                instance_name,
                team_name,
                "(A4-title)/2")
  }
  
}

plot_bar_capabilities = function(instance_name, team_name, export = F) {
  
  parts = as.data.frame(repo[[instance_name]]$CoreData$parts)
  # teamparts = as.data.frame(repo[[instance_name]]$CoreData$teamparts)
  # parts = merge(parts, teamparts, by = c('user'), all.y = T)
  parts = parts[!is.na(parts$exExpct1), c('user','isOrg',paste0('exCap',1:7))]
  
  for (cl in paste0('exCap',1:7)) {
    parts[[cl]] = factor(parts[[cl]],
                         levels = c(1,2,3),
                         labels = c('No',
                                    'Somewhat',
                                    'Significantly'))
  }
  # parts = parts[parts$isOrg,]
  D = likert(parts[,3:9])
  p = plot(D,
           plot.percent.low = F,
           plot.percent.high = F,
           plot.percents = T,
           center = 1.5,
           include.center = T,
           group.order = paste0('exCap',1:7),
           ordered = T,
           colors = c("#f57f17", "#cddc39", "#7cb342"),
           text.size = 2,
           legend.position = 'top') +
    scale_x_discrete(
      breaks = paste0('exCap',1:7),
      labels = c(
        'Analytic report\nwriting',
        'Using structured\nanalytic techniques',
        'Using OSINT tools\nandresources',
        'Applying strategic\nthinking frameworks',
        'Identifying and\nanalysing assumptions',
        'Evaluating quality of\nanalytic reasoning',
        'Using decision making\nframeworks'
      )
    ) +
    theme_huntlab() +
    theme(
      panel.background = element_rect(fill = '#f6f6f6'),
      axis.text.y = element_text(size = 9, colour = '#000000')
    )
  
  p = p + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'WERE NEW SKILLS LEARNT?',
      subtitle = 'Stacked bar chart indicating the extent to which participants reported they learnt new skills in\nseveral areas. Participants were responding to the prompt: "After participating in the Challenge, do\nyou think your capability has improved in the following areas?"',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "bar_capabilities.png",
                instance_name,
                team_name,
                "(A4-title)/2.5")
  }
  
}

plot_bar_platform = function(instance_name, team_name, export = F) {
  
  parts = as.data.frame(repo[[instance_name]]$CoreData$parts)
  # teamparts = as.data.frame(repo[[instance_name]]$CoreData$teamparts)
  # parts = merge(parts, teamparts, by = c('user'), all.y = T)
  parts = parts[!is.na(parts$exExpct1), c('user','isOrg',paste0('pf',1:14))]
  
  for (cl in paste0('pf',1:14)) {
    parts[[cl]] = factor(parts[[cl]],
                         levels = c(1,2,3),
                         labels = c('No',
                                    'Not sure',
                                    'Yes'))
  }
  parts = parts[parts$isOrg,]
  D = likert(parts[,3:16])
  p = plot(D,
           plot.percent.low = F,
           plot.percent.high = F,
           plot.percents = T,
           center = 2,
           include.center = T,
           group.order = paste0('pf',1:14),
           ordered = T,
           colors = c("#f57f17", "#b0bec5", "#7cb342"),
           text.size = 2,
           legend.position = 'top') +
    scale_x_discrete(
      breaks = paste0('pf',1:14),
      labels = c(
        'Developing a shared mission\namongst team members',
        'Working towards a\nunified goal',
        'Managing\ncontributions',
        'Keeping track of\nteam decisions',
        'Working in flexible and agile\nway as analysis progressed',
        'Innovative problem\nsolving',
        'Enabling an\nefficient workflow',
        'Meeting\ndeadlines',
        'Clear communication amongst\nteam members',
        'Ability to move easily between engaging with\nothers, or disengaging for independent work',
        'Information sharing\namongst team members',
        'Worked together\npositively',
        'Making\ndecisions',
        'Production of\nuseful output'
      )
    ) +
    theme_huntlab() +
    theme(
      panel.background = element_rect(fill = '#f6f6f6'),
      axis.text.y = element_text(size = 9, colour = '#000000')
    )
  
  p = p + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'DID THE PLATFORM HELP?',
      subtitle = 'Stacked bar chart indicating the extent to which participants reported they felt the SWARM platform\nwas useful in several areas. Participants were responding to the prompt: "Do you think the Platform\nsupported you in the following areas?"',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "bar_platform.png",
                instance_name,
                team_name,
                "(A4-title)/2")
  }
  
}

plot_bar_challenge = function(instance_name, team_name, export = F) {
  
  qs = paste0('cha',1:3)
  
  parts = as.data.frame(repo[[instance_name]]$CoreData$parts)
  # teamparts = as.data.frame(repo[[instance_name]]$CoreData$teamparts)
  # parts = merge(parts, teamparts, by = c('user'), all.y = T)
  parts = parts[!is.na(parts$exExpct1), c('user','isOrg',qs)]
  
  for (cl in qs) {
    parts[[cl]] = factor(parts[[cl]],
                         levels = c(1,2,3),
                         labels = c('Disagree',
                                    'Neutral',
                                    'Agree'))
  }
  # parts = parts[parts$isOrg,]
  D = likert(parts[,3:5])
  p = plot(D,
           plot.percent.low = F,
           plot.percent.high = F,
           plot.percents = T,
           center = 2,
           include.center = T,
           group.order = qs,
           ordered = T,
           colors = c("#f57f17", "#b0bec5", "#7cb342"),
           text.size = 2,
           legend.position = 'top') +
    scale_x_discrete(
      breaks = qs,
      labels = c(
        'A Challenge exercise\nis more effective',
        'A Challenge exercise\nis more engaging',
        'A Challenge exercise works better for some\npeople, but not as well for others'
      )
    ) +
    theme_huntlab() +
    theme(
      panel.background = element_rect(fill = '#f6f6f6'),
      axis.text.y = element_text(size = 9, colour = '#000000')
    )
  
  p = p + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'IS THE CHALLENGE BETTER TRAINING?',
      subtitle = 'Stacked bar chart describing participants responses to the prompt: "If you consider participating in an\nexercise like the HC2020 as analytical skills training, how does it compare with more typical training\nmethods?"',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "bar_challenge.png",
                instance_name,
                team_name,
                "(A4-title)/3.5")
  }
  
}


plot_bar_CA = function(instance_name, team_name, export = F) {
  
  qs = paste0('ca',1:4)
  
  parts = as.data.frame(repo[[instance_name]]$CoreData$parts)
  # teamparts = as.data.frame(repo[[instance_name]]$CoreData$teamparts)
  # parts = merge(parts, teamparts, by = c('user'), all.y = T)
  parts = parts[!is.na(parts$exExpct1), c('user','isOrg',qs)]
  
  for (cl in qs) {
    parts[[cl]] = factor(parts[[cl]],
                         levels = c(1,2,3),
                         labels = c('No',
                                    'Not sure',
                                    'Yes'))
  }
  # parts = parts[parts$isOrg,]
  D = likert(parts[,3:(2 + length(qs))])
  p = plot(D,
           plot.percent.low = F,
           plot.percent.high = F,
           plot.percents = T,
           center = 2,
           include.center = T,
           group.order = qs,
           ordered = T,
           colors = c("#f57f17", "#b0bec5", "#7cb342"),
           text.size = 2,
           legend.position = 'top') +
    scale_x_discrete(
      breaks = qs,
      labels = c(
        'I understood what\nContending Analyses is',
        'My team used\nContending Analyses',
        'Using Contending Analyses helped improve\nthe quality of reasoning in reports',
        'I intend to apply Contending\nAnalyses in my work'
      )
    ) +
    theme_huntlab() +
    theme(
      panel.background = element_rect(fill = '#f6f6f6'),
      axis.text.y = element_text(size = 9, colour = '#000000')
    )
  
  p = p + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'CONTENDING ANALYSES',
      subtitle = 'Stacked bar chart describing participants responses to the prompt: "Thinking about Contending Analyses,\ndo you agree or disagree with the following statements?"',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "bar_CA.png",
                instance_name,
                team_name,
                "(A4-title)/3.8")
  }
  
}

plot_bar_swarm = function(instance_name, team_name, export = F) {
  
  qs = paste0('swarm',1:4)
  
  parts = as.data.frame(repo[[instance_name]]$CoreData$parts)
  # teamparts = as.data.frame(repo[[instance_name]]$CoreData$teamparts)
  # parts = merge(parts, teamparts, by = c('user'), all.y = T)
  parts = parts[!is.na(parts$exExpct1), c('user','isOrg',qs)]
  
  for (cl in qs) {
    parts[[cl]] = factor(parts[[cl]],
                         levels = c(1,2,3,4,5),
                         labels = c('Strongly disagree',
                                    'Disagree',
                                    'Neutral',
                                    'Agree',
                                    'Strongly agree'))
  }
  # parts = parts[parts$isOrg,]
  D = likert(parts[,3:(2 + length(qs))])
  p = plot(D,
           plot.percent.low = F,
           plot.percent.high = F,
           plot.percents = T,
           center = 3,
           include.center = T,
           group.order = qs,
           ordered = T,
           colors = c('#e64a19', "#f57f17", "#b0bec5", "#cddc39", "#7cb342"),
           text.size = 2,
           legend.position = 'top') +
    scale_x_discrete(
      breaks = qs,
      labels = c(
        'Working on the Platform produced better\nreasoned reports than my normal methods',
        'My team’s reports were better than\nI could have produced on my own.',
        'Using a Platform like this would improve\nintelligence analysis in my organisation.',
        'If my organisation introduced a Platform\nlike this, I would want to use it.'
      )
    ) +
    guides(fill = guide_legend(ncol = 3)) +
    theme_huntlab() +
    theme(
      panel.background = element_rect(fill = '#f6f6f6'),
      axis.text.y = element_text(size = 9, colour = '#000000')
    )
  
  p = p + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'SWARM PLATFORM',
      subtitle = 'Stacked bar chart describing participants responses to the prompt: "Thinking about the Platform, do you\nagree or disagree with the following statements?"',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "bar_swarm.png",
                instance_name,
                team_name,
                "(A4-title)/3.5")
  }
  
}

plot_qor_boxplot = function(instance_name, team_name, export = F) {
  
  probteams = as.data.frame(repo[[instance_name]]$CoreData$probteams)
  probteams = probteams[!is.na(probteams$avgIC),]
  probteams$phase = 'Problems 1 & 2'
  probteams[probteams$probNum > 2,]$phase = 'Problems 3 & 4'
  
  p = ggplot(probteams, aes(x = type, y = avgIC, col = type)) +
    geom_boxplot(alpha = .8) + ylim(8,32) +
    facet_wrap(vars(phase),
               scales = 'free_x') +
    scale_colour_manual(breaks = c("PT","ST","OT"),
                      values = c("#00a087", "#f9a825", "#3c5488")) +
    scale_fill_manual(breaks = c("PT","ST","OT"),
                      values = c("#00a087", "#f9a825", "#3c5488")) +
    labs(
      x = NULL,
      y = 'IC Rating Scale',
      fill = 'Type',
      colour = 'Type'
    ) +
    theme_huntlab() +
    theme(panel.grid.major.y = element_line(size = .5, colour = "#f6f6f6"),
          panel.grid.minor.y = element_line(size = .5, colour = "#f6f6f6")
          )
  
    p = p + plot_layout(guides = "keep") +
    plot_annotation(
      title = 'ORGANISATIONAL VS PUBLIC TEAMS',
      subtitle = 'Box plots showing spread of quality of reasoning scores in each phase of the challenge, by team type.',
      theme = theme(plot.margin = margin(11, 10, 10, 10, "pt"),
                    plot.background = element_rect(fill = "#f6f6f6"),
                    plot.title = element_text(face = "bold",
                                              colour = "#014085"))
    )
  
  if (export) {
    export_plot(p,
                "qor_boxplot.png",
                instance_name,
                team_name,
                "(A4-title)/3")
  }
  
}
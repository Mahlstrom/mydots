# STATUSBAR
set -g status-interval 60

set -g status-left-length 100
set -g status-right-length 100

set -g status-style bg=default
set -g status-left-style fg=colour0,bg=colour$HOST_COLOR
set -g status-left '#[bold]#{?#{N/s:_popup_#S},+, }#S #[nobold]│ #h │ %H:%M '
set -g status-right-style fg=colour250
set -g status-right '#[reverse] #(cat /proc/loadavg) %H:%M '

# WINDOW INDICATORS
set -g window-status-separator ' '
set -g window-status-format '#I#{?#{window_zoomed_flag},+, }│ #W#{?window_last_flag,last,not last}'
set -g window-status-style fg=colour245,bg=default
set -g window-status-activity-style fg=colour$HOST_COLOR,bg=default,bold
set -g window-status-bell-style fg=colour0,bg=colour$HOST_COLOR,bold
set -g window-status-current-format '#[fg=colour240] #[fg=colour231]#I#{?#{window_zoomed_flag},+, }│ #W'
set -g window-status-current-style fg=colour231,bg=colour240,bold

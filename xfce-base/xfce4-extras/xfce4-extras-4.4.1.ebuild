# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce4-extras/xfce4-extras-4.4.1.ebuild,v 1.3 2007/04/28 17:49:03 nixnut Exp $

DESCRIPTION="Meta ebuild for panel plugins and other extra applications"
HOMEPAGE="http://www.xfce.org/"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="battery cpufreq hal gnome lm_sensors wifi"

RDEPEND=">=xfce-extra/xfce4-clipman-0.8
	>=xfce-extra/xfce4-datetime-0.5
	>=xfce-extra/xfce4-dict-0.2.1
	>=xfce-extra/xfce4-mount-0.5.1
	>=xfce-extra/xfce4-notes-1.4.1
	>=xfce-extra/xfce4-quicklauncher-1.9.2
	>=xfce-extra/xfce4-screenshooter-1
	>=xfce-extra/xfce4-systemload-0.4.2
	>=xfce-extra/xfce4-weather-0.6
	>=xfce-extra/xfce4-xkb-0.4.3
	>=xfce-extra/xfce4-netload-0.4
	>=xfce-extra/xfce4-fsguard-0.3
	>=xfce-extra/xfce4-cpugraph-0.3
	>=xfce-extra/xfce4-taskmanager-0.3.2-r1
	>=xfce-extra/xfce4-timer-0.5.1
	>=xfce-extra/xfce4-diskperf-2.1
	>=xfce-extra/xfce4-genmon-3.1
	>=xfce-extra/xfce4-smartbookmark-0.4.2
	>=xfce-extra/xfce4-mailwatch-1.0.1
	>=xfce-extra/xfce4-places-0.2
	>=xfce-extra/xfce4-eyes-4.4
	>=xfce-extra/verve-0.3.5
	>=xfce-extra/thunar-thumbnailers-0.2.0
	>=xfce-extra/thunar-archive-0.2.4-r1
	>=xfce-extra/thunar-media-tags-0.1.2
	hal? ( >=xfce-extra/thunar-volman-0.1.2 )
	cpufreq? ( >=xfce-extra/xfce4-cpu-freq-0.0.1 )
	gnome? ( >=xfce-extra/xfce4-xfapplet-0.1 )
	battery? ( >=xfce-extra/xfce4-battery-0.5 )
	wifi? ( >=xfce-extra/xfce4-wavelan-0.5.4 )
	lm_sensors? ( >=xfce-extra/xfce4-sensors-0.10.0-r1 )"

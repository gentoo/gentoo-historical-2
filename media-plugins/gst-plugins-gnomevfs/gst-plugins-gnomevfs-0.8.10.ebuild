# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-gnomevfs/gst-plugins-gnomevfs-0.8.10.ebuild,v 1.5 2005/08/29 21:48:21 gmsoft Exp $

inherit gst-plugins

KEYWORDS="~alpha ~amd64 ~arm hppa ia64 ~mips ~ppc ~ppc64 sparc x86"
IUSE=""

DEPEND=">=gnome-base/gnome-vfs-2"

GST_PLUGINS_BUILD="gnome_vfs"

# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-gnomevfs/gst-plugins-gnomevfs-0.8.8.ebuild,v 1.6 2005/05/06 12:05:11 corsair Exp $

inherit gst-plugins

KEYWORDS="x86 ppc sparc ~alpha ~hppa amd64 ~ia64 ~mips ~arm ~ppc64"
IUSE=""

DEPEND=">=gnome-base/gnome-vfs-2"

GST_PLUGINS_BUILD="gnome_vfs"

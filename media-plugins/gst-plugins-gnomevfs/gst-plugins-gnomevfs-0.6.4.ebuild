# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-gnomevfs/gst-plugins-gnomevfs-0.6.4.ebuild,v 1.10 2004/05/14 03:26:04 geoman Exp $

inherit gst-plugins

KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64 mips"
IUSE=""

DEPEND=">=gnome-base/gnome-vfs-2"

GST_PLUGINS_BUILD="gnome_vfs"

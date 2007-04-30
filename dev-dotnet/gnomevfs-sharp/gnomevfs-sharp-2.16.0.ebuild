# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gnomevfs-sharp/gnomevfs-sharp-2.16.0.ebuild,v 1.7 2007/04/30 17:38:11 uberlord Exp $

GTK_SHARP_TARBALL_PREFIX="gnome-sharp"
GTK_SHARP_REQUIRED_VERSION="2.10"

inherit gtk-sharp-component

SLOT="2"
KEYWORDS="amd64 ppc ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="${DEPEND}
		>=gnome-base/gnome-vfs-2.16.0"

GTK_SHARP_COMPONENT_SLOT="2"
GTK_SHARP_COMPONENT_SLOT_DEC="-2.0"

# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-eazel/gtk-engines-eazel-0.3.ebuild,v 1.3 2002/11/28 05:20:55 leonardop Exp $

DESCRIPTION="Eazel theme engine for GTK+"
SLOT="1"

inherit gtk-engines

newdepend media-libs/gdk-pixbuf
# This one needs the capplet stuff from gnomecc-1.4.  Some
# tests also need libglade, but it is a heavy dep, so dont
# know if we should rather disabled the tests...
newdepend "=gnome-base/control-center-1.4*"

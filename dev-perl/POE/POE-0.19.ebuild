# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Per Wigren <wigren@home.se>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE/POE-0.19.ebuild,v 1.1 2002/05/11 17:49:03 agenkin Exp $

DESCRIPTION="A framework for creating multitasking programs in Perl"
HOMEPAGE="http://poe.perl.org"

SRC_URI="http://poe.perl.org/poedown/${P}.tar.gz"
S=${WORKDIR}/${P}

DEPEND=">=sys-devel/perl-5
	dev-perl/Event
	dev-perl/Time-HiRes
	dev-perl/Compress-Zlib
	dev-perl/Storable
	dev-perl/IO-Tty
	dev-perl/Filter
	tcltk?  (dev-perl/perl-tk)
	gtk?    (dev-perl/gtk-perl)
	libwww? (dev-perl/libwww-perl)
	curses? (dev-perl/Curses)"

. /usr/portage/eclass/inherit.eclass || die
inherit perl-module

mymake="/usr"

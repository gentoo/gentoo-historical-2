# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE/POE-0.19.ebuild,v 1.11 2002/10/17 16:43:15 bjb Exp $

IUSE="gtk tcltk libwww curses"

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A framework for creating multitasking programs in Perl"
HOMEPAGE="http://poe.perl.org"
SRC_URI="http://poe.perl.org/poedown/${P}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc sparc64 alpha"

DEPEND="${DEPEND}
	dev-perl/Event
	dev-perl/Time-HiRes
	dev-perl/Compress-Zlib
	dev-perl/Storable
	dev-perl/IO-Tty
	dev-perl/Filter
	tcltk? ( dev-perl/perl-tk )
	gtk? ( dev-perl/gtk-perl )
	libwww? ( dev-perl/libwww-perl )
	curses? ( dev-perl/Curses )"

mymake="/usr"

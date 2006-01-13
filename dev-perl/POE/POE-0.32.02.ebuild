# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE/POE-0.32.02.ebuild,v 1.5 2006/01/13 22:13:11 mcummings Exp $

IUSE="gtk ipv6 libwww ncurses tcltk"

inherit perl-module
MY_PV=${PV/.02/02}
MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A framework for creating multitasking programs in Perl"
HOMEPAGE="http://search.cpan.org/~rcaputo/${MY_P}/"
SRC_URI="mirror://cpan/authors/id/R/RC/RCAPUTO/${MY_P}.tar.gz"

SLOT="0"
LICENSE="as-is"
#KEYWORDS="~ppc ~sparc ~x86"
KEYWORDS="~ppc sparc x86"

DEPEND="dev-perl/ExtUtils-AutoInstall
	>=dev-perl/Event-1.00
	>=perl-core/Time-HiRes-1.59
	>=dev-perl/Compress-Zlib-1.33
	>=perl-core/Storable-2.12
	>=dev-perl/IO-Tty-1.02
	perl-core/Filter
	>=perl-core/File-Spec-0.87
	>=perl-core/Test-Harness-2.26
	dev-perl/FreezeThaw
	>=perl-core/Test-Simple-0.54
	>=dev-perl/TermReadKey-2.21
	ipv6? ( >=dev-perl/Socket6-0.14 )
	tcltk? ( >=dev-perl/perl-tk-800.027 )
	gtk? ( >=dev-perl/gtk-perl-0.7009 )
	libwww? ( >=dev-perl/libwww-perl-5.79
		>=dev-perl/URI-1.30 )
	ncurses? ( >=dev-perl/Curses-1.08 )"

mymake="/usr"

src_compile() {
	echo "n" | perl-module_src_compile
}

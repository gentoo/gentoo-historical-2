# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/xgamer/xgamer-0.2.1.ebuild,v 1.4 2010/02/02 06:02:02 mr_bones_ Exp $

EAPI=2
inherit perl-module

DESCRIPTION="A launcher for starting games in a second X session"
HOMEPAGE="http://code.google.com/p/xgamer/"
SRC_URI="http://xgamer.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8
	>=x11-libs/gtk+-2.16
	>=dev-perl/gtk2-perl-1.120
	>=x11-wm/openbox-3.0.0
	virtual/perl-File-Spec
	dev-perl/File-BaseDir
	dev-perl/XML-Simple
	dev-perl/glib-perl
	x11-misc/numlockx
	media-gfx/feh"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

S=${WORKDIR}/${PN}

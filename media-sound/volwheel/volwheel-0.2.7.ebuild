# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/volwheel/volwheel-0.2.7.ebuild,v 1.2 2010/07/25 21:49:57 ssuominen Exp $

EAPI=2
inherit perl-app

MY_P=${P}-fixed

DESCRIPTION="A volume control trayicon with mouse wheel support"
HOMEPAGE="http://oliwer.net/b/volwheel.html"
SRC_URI="http://olwtools.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/gtk2-perl
	dev-perl/gtk2-trayicon
	alsa? ( media-sound/alsa-utils )"

S=${WORKDIR}/${MY_P}

src_install() {
	./install.pl prefix=/usr destdir="${D}" install || die
	dodoc ChangeLog README TODO
}

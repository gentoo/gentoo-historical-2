# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/opendesktop-fonts/opendesktop-fonts-1.3.0.ebuild,v 1.1 2008/05/31 06:59:37 loki_val Exp $

inherit font

DESCRIPTION="Chinese TrueType FireFly Fonts"
HOMEPAGE="http://www.study-area.org/apt/firefly-font/"
SRC_URI="http://www.study-area.org/apt/firefly-font/fireflysung-1.3.0.tar.gz"

LICENSE="Arphic"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~ppc s390 sh sparc x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}"/fireflysung-1.3.0
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="AUTHORS Changelog*"

# Only installs fonts
RESTRICT="strip binchecks"

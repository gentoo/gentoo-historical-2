# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ripperx/ripperx-2.6.6.ebuild,v 1.1 2005/09/19 03:32:52 vanquirius Exp $

MY_P="${P/x/X}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="RipperX is a program to rip CD and encode mp3s"
HOMEPAGE="http://ripperx.sf.net/"
SRC_URI="mirror://sourceforge/ripperx/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*
	media-sound/lame
	media-sound/cdparanoia
	media-libs/id3lib
	media-libs/flac"

src_install () {
	dodoc CHANGES FAQ README* TODO

	into /usr
	dobin src/ripperX plugins/ripperX_plugin-8hz-mp3 \
	plugins/ripperX_plugin-bladeenc plugins/ripperX_plugin-cdparanoia \
	plugins/ripperX_plugin-encode plugins/ripperX_plugin-gogo plugins/ripperX_plugin-l3enc \
	plugins/ripperX_plugin-lame plugins/ripperX_plugin-mp3enc plugins/ripperX_plugin-oggenc \
	plugins/ripperX_plugin-xingmp3enc plugins/ripperX_plugin_tester \
	plugins/ripperX_plugin-flac
}

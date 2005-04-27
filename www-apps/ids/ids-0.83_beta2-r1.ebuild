# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/ids/ids-0.83_beta2-r1.ebuild,v 1.4 2005/04/27 13:34:31 sekretarz Exp $

inherit webapp

MY_P=${P/_beta/b}
DESCRIPTION="IDS (Image Display System) is a CGI written in Perl that interactively generates a photo album website"
HOMEPAGE="http://ids.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="BSD"
IUSE=""
KEYWORDS="~x86 ~sparc ~ppc"
RDEPEND="net-www/apache
	>=dev-lang/perl-5.6.1
	dev-perl/ImageInfo
	>=media-gfx/imagemagick-6.2.2.0"

S=${WORKDIR}/${PN}

src_install() {
	webapp_src_preinst

	dodoc CREDITS ChangeLog PATCH.SUBMISSION README

	cp -R . ${D}/${MY_HTDOCSDIR}
	webapp_serverowned ${MY_HTDOCSDIR}/image-cache

	# add post-installation instructions
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}

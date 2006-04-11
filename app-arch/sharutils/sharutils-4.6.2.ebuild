# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/sharutils/sharutils-4.6.2.ebuild,v 1.1 2006/04/11 21:12:43 dragonheart Exp $

inherit autotools

MY_P="${P/_/-}"
DESCRIPTION="Tools to deal with shar archives"
HOMEPAGE="http://www.gnu.org/software/sharutils/"
SRC_URI="mirror://gnu/${PN}/REL-${PV}/${P}.tar.bz2
		doc? ( mirror://gnu/${PN}/REL-${PV}/${P}-doc.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls doc"

DEPEND="sys-apps/texinfo
	nls? ( >=sys-devel/gettext-0.10.35 )"

S=${WORKDIR}/${MY_P}

src_compile() {
	strip-linguas -u po/
	econf $(use_enable nls) || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
	if use doc ; then
		mv html_chapter/ html_node sharutils.html html_mono/ \
			pdf/sharutils.pdf.gz "${D}/usr/share/doc/${PF}" \
			|| die 'documentation installation failed'
		rm "${D}/usr/share/doc/${PF}"/*/*.gz
	fi
}

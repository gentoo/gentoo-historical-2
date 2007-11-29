# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-perl/claws-mail-perl-0.9.11.ebuild,v 1.1 2007/11/29 23:01:12 ticho Exp $

MY_P="${PN#claws-mail-}_plugin-${PV}"

DESCRIPTION="Plugin for sylpheed-claws to use perl to write filtering rules"
HOMEPAGE="http://www.claws-mail.org"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""
DEPEND=">=mail-client/claws-mail-3.1.0
		dev-lang/perl"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf || die
	emake || die

	pod2man --section=1 --release=${PV} --name=cm_perl cm_perl.pod > cm_perl.1

	cd tools
	emake || die
}

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	doman cm_perl.1

	cd tools
	exeinto /usr/lib/claws-mail/tools
	doexe *.pl

	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}

pkg_postinst() {
	echo
	elog "The documentation for this plugin is contained in a manpage."
	elog "You can access it with 'man cm_perl'"
	echo
}

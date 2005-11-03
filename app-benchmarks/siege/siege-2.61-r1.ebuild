# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/siege/siege-2.61-r1.ebuild,v 1.1 2005/11/03 21:55:37 ka0ttic Exp $

inherit eutils bash-completion

DESCRIPTION="A HTTP regression testing and benchmarking utility"
HOMEPAGE="http://www.joedog.org/siege/"
SRC_URI="ftp://sid.joedog.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 mips ppc x86"
SLOT="0"
IUSE="ssl"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6d )"
RDEPEND="${DEPEND}
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-2.60-gentoo.diff
}

src_compile() {
	einfo "Running autoreconf"
	autoreconf || die "autoreconf failed"
	econf $(use_with ssl) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# bug 111057 - siege.config utility uses ${} which gets
	# interpreted by bash sending the contents to stderr
	# instead of ${HOME}/.siegerc
	sed -i -e 's|\${}|\\${}|' -e 's|\$(HOME)|\\$(HOME)|' \
		${D}/usr/bin/siege.config

	dodoc AUTHORS ChangeLog INSTALL MACHINES README KNOWNBUGS \
		siegerc-example urls.txt || die "dodoc failed"
	use ssl && dodoc README.https
	dobashcompletion ${FILESDIR}/${PN}.bash-completion ${PN}
}

pkg_postinst() {
	echo
	einfo "An example ~/.siegerc file has been installed as"
	einfo "/usr/share/doc/${PF}/siegerc-example.gz"
	bash-completion_pkg_postinst
}

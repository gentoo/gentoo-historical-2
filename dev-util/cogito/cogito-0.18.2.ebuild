# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cogito/cogito-0.18.2.ebuild,v 1.7 2008/04/01 22:33:35 opfer Exp $

inherit eutils

MY_PV=${PV//_/}

DESCRIPTION="The GIT scripted toolkit"
HOMEPAGE="http://git.or.cz/cogito/"
SRC_URI="mirror://kernel/software/scm/${PN}/${PN}-${MY_PV}.tar.bz2
	mirror://gentoo/${PN}-doc-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-util/git-1.4.3"
RDEPEND="app-text/rcs
	net-misc/curl"

S=${WORKDIR}/${PN}-${MY_PV}
SDOC=${WORKDIR}/${PN}-doc-${MY_PV}

src_unpack() {
	unpack ${A} ; cd "${S}"

	# t9300-seek won't work under the sandbox
	rm t/t9300-seek.sh
}

src_install() {
	emake install DESTDIR="${D}" prefix="/usr" || die "install failed"
	dodoc README* VERSION

	doman "${SDOC}"/man?/*

	dodir /usr/share/doc/${PF}/{,html,contrib}
	cp "${SDOC}"/html/* "${D}"/usr/share/doc/${PF}/html
	cp "${S}"/contrib/* "${D}"/usr/share/doc/${PF}/contrib
}

src_test() {
	# 'make test' from the root runs the tutorial-script which executes
	# other commands such as 'gpg' and creates stuff in portage's $HOME.
	cd "${S}"
	make -C t || die
}

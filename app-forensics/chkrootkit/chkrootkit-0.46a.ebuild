# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/chkrootkit/chkrootkit-0.46a.ebuild,v 1.1 2005/10/28 17:22:27 ka0ttic Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="a tool to locally check for signs of a rootkit"
HOMEPAGE="http://www.chkrootkit.org/"
SRC_URI="ftp://ftp.pangeia.com.br/pub/seg/pac/${P}.tar.gz
	mirror://gentoo/${PN}-0.45-gentoo.diff.bz2"

LICENSE="AMS"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}

	# we can use the gentoo patch for 0.45 but it needs one change to apply
	# cleanly -- certainly not enough to warrant using a separate 32k patch.
	sed -e 's|\(xlogin\)|\^\1|' ${WORKDIR}/${PN}-0.45-gentoo.diff > \
								 ${WORKDIR}/${P}-gentoo.diff
	epatch ${WORKDIR}/${P}-gentoo.diff

	epatch ${FILESDIR}/${PN}-0.45-makefile.diff
	epatch ${FILESDIR}/${PN}-0.46-add-missing-includes.diff

	sed -i 's:${head} -:${head} -n :' chkrootkit || die "sed chkrootkit failed"
	sed -i 's:/var/adm:/var/log:g' chklastlog.c || die "sed chklastlog.c failed"
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		sense || die "emake sense failed"
}

src_install() {
	dosbin chkdirs chklastlog chkproc chkrootkit chkwtmp chkutmp ifpromisc \
		strings-static || die
	dodoc ACKNOWLEDGMENTS README*

	exeinto /etc/cron.weekly
	newexe ${FILESDIR}/${PN}.cron ${PN} || die
}

pkg_postinst() {
	echo
	einfo "Edit /etc/cron.weekly/chkrootkit to activate chkrootkit!"
	einfo
	einfo "Some applications, such as portsentry, will cause chkrootkit"
	einfo "to produce false positives.  Read the chkrootkit FAQ at"
	einfo "http://www.chkrootkit.org/ for more information."
	echo
}

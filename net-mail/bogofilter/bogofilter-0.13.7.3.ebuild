# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/bogofilter/bogofilter-0.13.7.3.ebuild,v 1.5 2004/01/07 19:30:43 seemant Exp $

IUSE=""

S=${WORKDIR}/${P}
DESCRIPTION="Bayesian spam filter designed with fast algorithms, and tuned for speed."
HOMEPAGE="http://bogofilter.sourceforge.net/"
SRC_URI="mirror://sourceforge/bogofilter/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha ~hppa ~mips ~arm amd64 ia64"

DEPEND="virtual/glibc
	>=sys-libs/db-3"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	exeinto /usr/lib/${PN}/tuning
	insinto /usr/lib/${PN}/tuning
	doexe tuning/bogolex.sh tuning/bogol tuning/bogotune
	doins tuning/README.bogotune tuning/bogol.1 tuning/bogotune.1

	exeinto /usr/lib/${PN}/contrib
	doexe contrib/{bogofilter-qfe,bogogrep,mime.get.rfc822,parmtest.sh}
	doexe contrib/{printmaildir.pl,randomtrain,scramble,bogofilter-milter.pl}
	insinto /usr/lib/${PN}/contrib
	doins contrib/README.randomtrain contrib/bogo.R contrib/trainbogo.sh

	dodoc AUTHORS INSTALL COPYING METHODS NEWS README README.cvs TODO UPGRADE
	dodoc RELEASE.NOTES-0.1* CHANGES-0.1* doc/integrating-with-* doc/*.HOWTO
	dodoc contrib/mailfilter.example contrib/procmailrc.example

	dodir /usr/share/doc/${P}/samples
	mv ${D}/etc/* ${D}/usr/share/doc/${PF}/samples/
	rmdir ${D}/etc

	dohtml doc/*.html
	docinto programmer ; dodoc doc/programmer/*
}

pkg_postinst() {

	einfo "With version 0.11 the options of bogofilter have changed."
	einfo "If you update from an older version, you eventually must change"
	einfo "your configuration."
	einfo ""
	einfo "Read bogofilter's manual 'man bogofilter' and have a look at"
	einfo "the examples in the doc directory for tips on how"
	einfo "to integrate bogofilter with procmail, maildrop, postfix or qmail."
}

# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/dk-milter/dk-milter-0.4.1.ebuild,v 1.3 2006/07/15 23:47:37 langthang Exp $

inherit eutils

DESCRIPTION="A milter-based application provide DomainKeys service"

HOMEPAGE="http://sourceforge.net/projects/dk-milter/"

SRC_URI="mirror://sourceforge/dk-milter/${P}.tar.gz"

LICENSE="Sendmail-Open-Source"

SLOT="0"

KEYWORDS="~x86"


IUSE=""

DEPEND="dev-libs/openssl
	mail-filter/libmilter"

S=${WORKDIR}/${P}

pkg_setup() {
	enewgroup milter
	enewuser milter -1 -1 -1 milter
}

src_unpack() {
	unpack ${A}

	confCCOPTS="${CFLAGS}"
	conf_libmilter_INCDIRS="-I/usr/include/libmilter"
	sed -e "s:@@confCCOPTS@@:${confCCOPTS}:" \
		-e "s:@@conf_libmilter_INCDIRS@@:${conf_libmilter_INCDIRS}:" \
		"${FILESDIR}"/site.config.m4 > "${S}"/devtools/Site/site.config.m4 \
		|| die "sed failed"
}

src_install() {
	OBJDIR="obj.`uname -s`.`uname -r`.`arch`"

	# prepare directory for private keys.
	dodir /etc/mail/dk-filter
	keepdir /etc/mail/dk-filter
	fowners milter:milter /etc/mail/dk-milter
	fperms 700 /etc/mail/dk-milter

	dodir /usr/bin /usr/lib
	dodir /usr/share/man/man{3,8}
	for dir in dk-filter  libar  libdk  libsm; do
		make DESTDIR=${D} MANROOT=/usr/share/man/man \
			install -C "${OBJDIR}"/${dir} \
			|| die "make install failed"
	done
	dobin "$FILESDIR"/gentxt.sh || die "dobin failed"

	newinitd "${FILESDIR}/dk-filter.init" dk-filter \
		|| die "newinitd failed"
	newconfd "${FILESDIR}/dk-filter.conf" dk-filter \
		|| die "newconfd failed"
}

pkg_postinst() {
	enewgroup milter
	enewuser milter -1 -1 -1 milter
}

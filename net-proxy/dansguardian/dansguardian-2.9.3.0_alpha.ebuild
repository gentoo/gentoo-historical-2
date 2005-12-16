# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/dansguardian/dansguardian-2.9.3.0_alpha.ebuild,v 1.2 2005/12/16 06:29:17 mrness Exp $

inherit eutils

MY_P=${P/_alpha/}

DESCRIPTION="Web content filtering via proxy"
HOMEPAGE="http://dansguardian.org"
SRC_URI="http://dansguardian.org/downloads/2/Alpha/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="clamav debug ntlm pcre"

DEPEND="virtual/libc
	!net-proxy/dansguardian-dgav
	pcre? ( dev-libs/libpcre )
	clamav? ( app-antivirus/clamav )"

S=${WORKDIR}/${MY_P}

MY_REFRESH_LOG_OWNER=""

pkg_setup() {
	if has_version "<${CATEGORY}/${PN}-2.9" ; then
		ewarn "This version introduces brand new USE flags:"
		ewarn "   clamav ntlm pcre"
		echo

		local f="${ROOT}/etc/dansguardian"
		f=${f//\/\///}
		if [ -d "${f}" ] ; then
			eerror "The structure of ${f} has changed in this version!"
			eerror "For avoiding confusion, you must either move or delete the old ${f},"
			eerror "then continue with the upgrade:"
			eerror "   mv '${f}' '${f}.old'"
			eerror "   emerge --resume"
			die "Obsolete config files detected"
		fi
	fi
}

src_unpack() {
	unpack ${A}

	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	local myconf="--with-logdir=/var/log/dansguardian
		--with-piddir=/var/run
		$(use_enable pcre)
		$(use_enable ntlm)"
	if use clamav; then
		myconf="${myconf} --enable-clamd=yes
			--with-proxyuser=clamav
			--with-proxygroup=clamav"
	fi
	if use debug; then
		myconf="${myconf} --with-dgdebug=on"
	fi

	econf ${myconf} || die "configure failed"

	emake OPTIMISE="${CFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	# Copying init script
	exeinto /etc/init.d
	newexe ${FILESDIR}/dansguardian.init dansguardian

	if use clamav; then
		sed -r -i -e 's/[ \t]+need net.*/& clamd/' ${D}/etc/init.d/dansguardian
		sed -r -i -e 's/^#( *contentscanner *=.*clamdscan[.]conf.*)/\1/' ${D}/etc/dansguardian/dansguardian.conf
		sed -r -i -e 's/^#( *clamdudsfile *=.*)/\1/' ${D}/etc/dansguardian/contentscanners/clamdscan.conf
	fi

	# Copying logrotation file
	exeinto /etc/logrotate.d
	newexe ${FILESDIR}/dansguardian.logrotate dansguardian

	keepdir /var/log/dansguardian
	fperms o-rwx /var/log/dansguardian
}

pkg_postinst() {
	local runas="nobody:nobody"
	if use clamav ; then
		runas="clamav:clamav"
	fi
	ewarn "The dansguardian daemon will run by default as user & group ${runas}"

	if has_version "<${CATEGORY}/${PN}-2.9" && [ -d "${ROOT}/var/log/dansguardian" ] ; then
		chown -R ${runas} "${ROOT}/var/log/dansguardian"
		chmod o-rwx "${ROOT}/var/log/dansguardian"
	fi
}

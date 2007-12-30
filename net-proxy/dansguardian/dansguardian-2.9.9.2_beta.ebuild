# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/dansguardian/dansguardian-2.9.9.2_beta.ebuild,v 1.1 2007/12/30 11:35:14 mrness Exp $

inherit eutils

MY_P=${P/_beta/}

DESCRIPTION="Web content filtering via proxy"
HOMEPAGE="http://dansguardian.org"
SRC_URI="http://dansguardian.org/downloads/2/Beta/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="clamav kaspersky debug ntlm pcre"

DEPEND="pcre? ( >=dev-libs/libpcre-6.0 )
	clamav? ( app-antivirus/clamav )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if has_version "<${CATEGORY}/${PN}-2.9" ; then
		ewarn "This version introduces brand new USE flags:"
		ewarn "   clamav kaspersky ntlm pcre"
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

	epatch "${FILESDIR}/${P%_beta}-gentoo.patch"
}

src_compile() {
	local myconf="--with-logdir=/var/log/dansguardian
		--with-piddir=/var/run
		$(use_enable pcre)
		$(use_enable ntlm)
		--enable-fancydm
		--enable-email"
	if use clamav; then
		myconf="${myconf} --enable-clamd --enable-clamav
			--with-proxyuser=clamav
			--with-proxygroup=clamav"
	fi
	if use kaspersky; then
		myconf="${myconf} --enable-kavd"
	fi
	if use debug; then
		myconf="${myconf} --with-dgdebug=on"
	fi

	econf ${myconf} || die "configure failed"

	emake OPTIMISE="${CFLAGS}" || die "emake failed"
}

src_install() {
	make "DESTDIR=${D}" install || die "make install failed"

	# Copying init script
	newinitd "${FILESDIR}/dansguardian.init" dansguardian

	if use clamav; then
		sed -r -i -e 's/[ \t]+use dns/& clamd/' "${D}/etc/init.d/dansguardian"
		sed -r -i -e 's/^#( *contentscanner *=.*clamdscan[.]conf.*)/\1/' "${D}/etc/dansguardian/dansguardian.conf"
		sed -r -i -e 's/^#( *clamdudsfile *=.*)/\1/' "${D}/etc/dansguardian/contentscanners/clamdscan.conf"
	elif use kaspersky; then
		sed -r -i -e 's/^#( *contentscanner *=.*kavdscan[.]conf.*)/\1/' "${D}/etc/dansguardian/dansguardian.conf"
	fi

	# Copying logrotation file
	insinto /etc/logrotate.d
	newins "${FILESDIR}/dansguardian.logrotate" dansguardian

	keepdir /var/log/dansguardian
	fperms o-rwx /var/log/dansguardian

	# TODO : see if no-default-lists.patch and these linea are still needed in next version
	local f
	touch "${T}"/emptyfile
	insinto /etc/dansguardian/lists
	for f in exceptionfileurllist bannedregexpheaderlist logsitelist logurllist headerregexplist logregexpurllist; do
		if [ -f "${f}" ] ; then
			einfo "${f} already exists"
		else
			newins "${T}"/emptyfile ${f}
		fi
	done
}

pkg_postinst() {
	local runas="nobody:nobody"
	if use clamav ; then
		runas="clamav:clamav"
	fi
	einfo "The dansguardian daemon will run by default as ${runas}"

	if [ -d "${ROOT}/var/log/dansguardian" ] ; then
		chown -R ${runas} "${ROOT}/var/log/dansguardian"
		chmod o-rwx "${ROOT}/var/log/dansguardian"
	fi
}

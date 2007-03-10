# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/pdnsd/pdnsd-1.2.5.ebuild,v 1.6 2007/03/10 14:03:48 mrness Exp $

inherit eutils

DESCRIPTION="Proxy DNS server with permanent caching"
HOMEPAGE="http://www.phys.uu.nl/~rombouts/pdnsd.html"
SRC_URI="http://www.phys.uu.nl/~rombouts/pdnsd/releases/${P}-par.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ppc s390 sparc x86"
IUSE="ipv6 debug isdn nptl underscores"

pkg_setup() {
	enewgroup pdnsd
	enewuser pdnsd -1 -1 /var/lib/pdnsd pdnsd
}

src_compile() {
	local myconf=""

	use debug && myconf="${myconf} --with-debug=3"
	use nptl && myconf="${myconf} --with-thread-lib=NPTL"

	[ -c /dev/urandom ] && myconf="${myconf} --with-random-device=/dev/urandom"

	econf \
		--sysconfdir=/etc/pdnsd \
		--with-cachedir=/var/cache/pdnsd \
		--infodir=/usr/share/info --mandir=/usr/share/man \
		--with-default-id=pdnsd \
		$(use_enable ipv6) \
		$(use_enable isdn) \
		$(use_enable underscores) \
		${myconf} \
		|| die "bad configure"

	emake all || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog* NEWS README THANKS TODO README.par
	docinto contrib ; dodoc contrib/{README,dhcp2pdnsd,pdnsd_dhcp.pl}
	docinto html ; dohtml doc/html/*
	docinto txt ; dodoc doc/txt/*
	newdoc doc/pdnsd.conf pdnsd.conf.sample

	newinitd "${FILESDIR}/pdnsd.rc6" pdnsd
	newinitd "${FILESDIR}/pdnsd.online" pdnsd-online

	keepdir /etc/conf.d
	local config="${D}/etc/conf.d/pdnsd-online"

	echo -e "# Enter the interface that connects you to the dns servers" >> "${config}"
	echo "# This will correspond to /etc/init.d/net.${IFACE}" >> "${config}"
	echo -e "\n# IMPORTANT: Be sure to run depscan.sh after modifiying IFACE" >> "${config}"
	echo "IFACE=ppp0" >> "${config}"

	config="${D}/etc/conf.d/pdnsd"
	"${D}/usr/sbin/pdnsd" --help | sed "s/^/# /g" > "${config}"
	echo "# Command line options" >> "${config}"
	use ipv6 && echo PDNSDCONFIG="-a" >> "${config}" \
		|| echo PDNSDCONFIG="" >> "${config}"

	#resolvconf-gentoo support
	exeinto /etc/resolvconf/update.d
	newexe "${FILESDIR}/pdnsd.resolvconf" pdnsd
}

src_test() {
	if [ -x /usr/bin/dig ];	then
		mkdir "${T}/pdnsd"
		echo -n -e "pd12\0\0\0\0" > "${T}/pdnsd/pdnsd.cache"
		IPS=$(grep ^nameserver /etc/resolv.conf | sed -e 's/nameserver \(.*\)/\tip=\1;/g' | xargs)
		sed -e "s/\tip=/${IPS}/" -e "s:cache_dir=:cache_dir=${T}/pdnsd:" "${FILESDIR}/pdnsd.conf.test" \
			> "${T}/pdnsd.conf.test"
		src/pdnsd -c "${T}/pdnsd.conf.test" -g -s -d -p "${T}/pid" || die "couldn't start daemon"
		sleep 3

		find "${T}" -ls
		[ -s "${T}/pid" ] || die "empty or no pid file created"
		[ -S "${T}/pdnsd/pdnsd.status" ] || die "no socket created"
		src/pdnsd-ctl/pdnsd-ctl -c "${T}/pdnsd" server all up || die "failed to start the daemon"
		src/pdnsd-ctl/pdnsd-ctl -c "${T}/pdnsd" status || die "failed to communicate with the daemon"
		sleep 3

		dig @127.0.0.1 -p 33455 www.gentoo.org  | fgrep "status: NOERROR" || die "www.gentoo.org lookup failed"
		kill $(<"${T}/pid") || die "failed to terminate daemon"
	fi
}

pkg_preinst() {
	# Duplicated so that binary packages work
	enewgroup pdnsd
	enewuser pdnsd -1 -1 /var/lib/pdnsd pdnsd

	# Copy cache from older versions
	[ -f "${ROOT}/var/lib/pdnsd/pdnsd.cache" ] && \
		cp "${ROOT}/var/lib/pdnsd/pdnsd.cache" "${D}/var/cache/pdnsd/pdnsd.cache"

	# Preserve the cache from previous version
	[ -f "${ROOT}/var/cache/pdnsd/pdnsd.cache" ] && \
		cp "${ROOT}/var/cache/pdnsd/pdnsd.cache" "${D}/var/cache/pdnsd/pdnsd.cache"
}

pkg_postinst() {
	einfo
	einfo "Add pdnsd to your default runlevel - rc-update add pdnsd default"
	einfo ""
	einfo "Add pdnsd-online to your online runlevel."
	einfo "The online interface will be listed in /etc/conf.d/pdnsd-online"
	einfo ""
	einfo "Sample config file in /etc/pdnsd/pdnsd.conf.sample"
}

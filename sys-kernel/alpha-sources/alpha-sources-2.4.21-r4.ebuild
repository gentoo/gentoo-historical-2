# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/alpha-sources/alpha-sources-2.4.21-r4.ebuild,v 1.2 2004/02/22 23:31:15 agriffis Exp $

#OKV=original kernel version, KV=patched kernel version.  They can be the same.

IUSE="build crypt usagi"
ETYPE="sources"
inherit kernel
OKV="`echo ${PV}|sed -e 's:^\([0-9]\+\.[0-9]\+\.[0-9]\+\).*:\1:'`"
EXTRAVERSION="-${PN/-*/}"
[ ! "${PR}" == "r0" ] && EXTRAVERSION="${EXTRAVERSION}-${PR}"
KV="${OKV}${EXTRAVERSION}"

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Gentoo Linux Alpha kernel"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
	mirror://gentoo/patches-${KV/r4/r3}.tar.bz2"
SLOT="${KV}"
KEYWORDS="alpha -sparc -x86 -ppc -hppa -mips "

src_unpack() {
	unpack ${A}
	mv linux-${OKV} linux-${KV} || die
	cd ${WORKDIR}/${KV/r4/r1}

	# This is the crypt USE flag, keeps {USAGI/superfreeswan/patch-int/loop-jari}
	if [ -z "`use crypt`" ]; then
	    einfo "No Cryptographic support, dropping patches..."
	    for file in 6* 8* ;do
		einfo "Dropping ${file}..."
		rm -f ${file}
	    done
	else
	    einfo "Cryptographic patches will be applied"
	fi

	# This is the usagi USE flag, keeps USAGI, drops
	# {superfreeswan/patch-int/loop-jari} 
	# Using USAGI will also cause you to drop all iptables ipv6
	# patches.
	if [ -z "`use usagi`" ]; then
		einfo "Keeping {superfreeswan/patch-int/loop-jari} patches, dropping USAGI"
		for file in 6* ;do
			einfo "Dropping ${file}..."
			rm -f ${file}
		done
	else
		einfo "Keeping USAGI patch, dropping {superfreeswan/patch-int/loop-jari}"
		for file in *.ipv6 8* ;do
			einfo "Dropping ${file}..."
			rm -f ${file}
		done
	fi

	kernel_src_unpack

	cd ${S}
	epatch ${FILESDIR}/do_brk_fix.patch || die "Failed to patch the do_brk() vulnerability!"
	epatch ${FILESDIR}/${PN}.CAN-2003-0985.patch || die "Failed to patch mremap() vulnerability!"
	epatch ${FILESDIR}/${PN}.rtc_fix.patch || die "Failed to patch RTC vulnerabilities!"
	epatch ${FILESDIR}/${PN}.munmap.patch || die "Failed to apply munmap patch!"

	# Fix multi-line literal in include/asm-alpha/xor.h -- see bug 38354
	# If this script "dies" then that means it's no longer applicable.
	mv include/asm-alpha/xor.h{,.multiline}
	awk 'BEGIN     { addnl=0; exitstatus=1 }
		 /^asm\("/ { addnl=1 }
		 /^"\)/    { addnl=0 }
		 addnl && !/\\n\\$/ { sub("$", " \\n\\", $0); exitstatus=0 }
				   { print }
		 END       { exit exitstatus }' \
		 <include/asm-alpha/xor.h.multiline >include/asm-alpha/xor.h
	assert "awk script failed, probably doesn't apply to ${KV}"
	rm -f include/asm-alpha/xor.h.multiline
}
